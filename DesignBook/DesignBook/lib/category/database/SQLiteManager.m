//
//  SQLiteManager.m
//  比颜值
//
//  Created by 陈行 on 15-12-1.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "SQLiteManager.h"
#import <objc/runtime.h>

static SQLiteManager * manager;

@interface SQLiteManager()

@property(nonatomic,strong)FMDatabase * db;

@property(nonatomic,strong)FMResultSet * rs;

@property(nonatomic,copy)NSString * appVersion;

@property(nonatomic,copy)NSString * databaseVersion;

@end

@implementation SQLiteManager

/**
 *  单例
 *
 *  @return SQLiteManager对象
 */
+ (SQLiteManager *)shareSQLiteManagerWithDatabasePath:(NSString *)databasePath{
    [self shareSQLiteManager];
    manager.databasePath=databasePath;
    return manager;
}

+ (SQLiteManager *)shareSQLiteManager{
    if(manager==nil){
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            manager=[[SQLiteManager alloc]init];
        });
    }
    return manager;
}

/**
 *  创建一张表
 *
 *  @param sql sql语句
 *
 *  @return 成功or失败
 */
- (BOOL)createTableWithSQL:(NSString *)sql{
    return [self DMLSQL:sql andArgumentsInArray:nil];
}

/**
 *  以下四个，增(or替换)删改
 *
 *  @param sql sql语句
 *
 *  @return 成功or失败
 */
- (BOOL)insertWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array{
    return [self DMLSQL:sql andArgumentsInArray:array];
}

- (BOOL)insertOrReplaceWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array{
    return [self DMLSQL:sql andArgumentsInArray:array];
}

- (BOOL)updateWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array{
    return [self DMLSQL:sql andArgumentsInArray:array];
}

- (BOOL)deleteWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array{
    return [self DMLSQL:sql andArgumentsInArray:array];
}
/**
 *  统一执行增加(或替换)删除修改操作
 *
 *  @param sql   sql语句
 *  @param array 参数
 *
 *  @return 成功or失败
 */
- (BOOL)DMLSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array{
    [self openDatabase];
    BOOL b=[self.db executeUpdate:sql withArgumentsInArray:array];
    [self closeDatabase];
    return b;
}
/**
 *  查询
 *
 *  @param sql   sql语句
 *  @param array 参数
 */
- (FMResultSet *)queryWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array{
    [self openDatabase];
    self.rs=[self.db executeQuery:sql withArgumentsInArray:array];
    return self.rs;
}

+ (BOOL)insertToTableName:(NSString *)tableName andObject:(id)object{
    NSMutableArray * valueArray=[[NSMutableArray alloc]init];
    
    NSArray * propertyArray=[self propertyArrayWithClass:[object class]];
    NSMutableString * str=[[NSMutableString alloc]init];
    NSMutableString * sql=[NSMutableString stringWithFormat:@"insert into %@(",tableName==nil? NSStringFromClass([object class]):tableName];
    for (int i=0;i<propertyArray.count;i++) {
        id value = [object valueForKey:propertyArray[i]];
        if(value){
            [valueArray addObject:value];
        }else{
            [valueArray addObject:@"NULL"];
        }
        if(i==0){
            [sql appendFormat:@"%@",propertyArray[i]];
            [str appendString:@"?"];
        }else{
            [sql appendFormat:@",%@",propertyArray[i]];
            [str appendString:@",?"];
        }
    }
    
    [sql appendFormat:@") values(%@);",str];
    
    return [[SQLiteManager shareSQLiteManager]insertWithSQL:sql andArgumentsInArray:valueArray];
}

+ (NSArray *)queryAllWithTableName:(NSString *)tableName andClass:(Class)clazz{
    NSArray * propertyArray=[self propertyArrayWithClass:clazz];
    NSMutableArray * dataArray=[[NSMutableArray alloc]init];
    
    NSString * sql=[NSString stringWithFormat:@"select * from %@;",tableName?tableName:NSStringFromClass(clazz)];
    FMResultSet * rs = [[self shareSQLiteManager] queryWithSQL:sql andArgumentsInArray:nil];
    while (rs.next) {
        id obj=[[clazz alloc]init];
        for (NSString * prop in propertyArray) {
            if(![rs columnIsNull:prop]){
                id value = [rs objectForColumnName:prop];
                if(value){
                    [obj setValue:value forKey:prop];
                }
            }
        }
        [dataArray addObject:obj];
    }
    [rs close];
    return dataArray;
}

+ (NSArray *)propertyArrayWithClass:(Class)clazz{
    NSMutableArray * array=[[NSMutableArray alloc]init];
    unsigned int count;
    
    objc_property_t * pros=class_copyPropertyList(clazz, &count);
    
    for(int i=0;i<count;i++){
        objc_property_t property= pros[i];
        const char * nameChar=property_getName(property);
        NSString * name=[NSString stringWithFormat:@"%s",nameChar];
        [array addObject:name];
    }
    free(pros);
    return array;
}

/**
 *  检查数据库，是否需要更新
 *
 *  @return
 */
+ (void)checkAndUpdateDatabaseVersion{
    SQLiteManager * manager= [self shareSQLiteManager];
    //获取ipa中的版本信息，
    NSString * path=[[NSBundle mainBundle]pathForResource:APPVERSION_PLIST ofType:nil];
    NSDictionary * dict=[NSDictionary dictionaryWithContentsOfFile:path];
    AppVersionInfo * versionInfo=[AppVersionInfo appVersionInfoWithDict:dict];
    manager.appVersion=versionInfo.appVersion;
    //看是否是首次安装
    NSString * databasePath=[NSString stringWithFormat:@"%@%@",NSHomeDirectory(),DATABASE_PATH];
    manager.databasePath=databasePath;
    NSFileManager * fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:databasePath]){//不存在
        manager.databaseVersion=VERSION_0;
        [manager updateDatabase];
        return;
    }
    
    //获取本地文件，取得数据库版本
    manager.databasePath=databasePath;
    NSString * sql=@"select * from version_info;";
    FMResultSet * rs = [manager queryWithSQL:sql andArgumentsInArray:nil];
    if(rs.next){
        manager.databaseVersion = [rs stringForColumn:@"database_version"];
    }
    //看数据库版本与app版本是否一致，不一致更新
    if(![manager.databaseVersion isEqualToString:manager.appVersion]){
        [manager updateDatabase];
    }
}

-(void)updateDatabase{
    if([self.databaseVersion isEqualToString:VERSION_0]){
        [self createTableWithSQL:VERSION_SQL_1_0_1];
        [self createTableWithSQL:VERSION_SQL_1_0_2];
        [self createTableWithSQL:VERSION_SQL_1_0_4];
        [self insertWithSQL:VERSION_SQL_1_0_3 andArgumentsInArray:nil];
        self.databaseVersion=VERSION_1_0;
    }else if ([self.databaseVersion isEqualToString:VERSION_1_0]){
        NSLog(@"进行下一次升级的更新");
    }
}
/**
 *  打开数据库
 *
 *  @return 成功or失败
 */
- (BOOL)openDatabase{
    
    if(![self.db open]){
        NSLog(@"打开数据库失败");
        return false;
    }
    return true;
}

/**
 *  关闭数据库
 *  释放sql文
 *  设置为没有正在执行sql文
 */
- (void)closeDatabase{
    if(self.rs){
        [self.rs close];
    }
    [self.db close];
}

/**
 *  懒加载
 *
 *  @return 
 */
- (FMDatabase *)db{
    if(_db==nil){
        _db=[FMDatabase databaseWithPath:self.databasePath];
    }
    return _db;
}

@end
