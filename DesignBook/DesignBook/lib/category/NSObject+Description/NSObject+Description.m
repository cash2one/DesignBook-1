//
//  NSObject+Description.m
//  my——QQ分组
//
//  Created by 陈行 on 15-11-11.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "NSObject+Description.h"
#import <objc/runtime.h>

typedef enum NSObjCValueType {
    NSObjCNoType = 0,
    NSObjCVoidType = 'v',
    NSObjCCharType = 'c',
    NSObjCByteType = 'C',
    NSObjCShortType = 's',
    NSObjCIntType = 'i',
    NSObjCLongType = 'l',
    NSObjCLonglongType = 'q',
    NSObjCFloatType = 'f',
    NSObjCDoubleType = 'd',
    NSObjCBoolType = 'B',
    NSObjCSelectorType = ':',
    NSObjCObjectType = '@',
    NSObjCStructType = '{',
    NSObjCPointerType = '^',
    NSObjCStringType = '*',
    NSObjCArrayType = '[',
    NSObjCUnionType = '(',
    NSObjCBitfield = 'b'
} NSObjCValueType;

struct NSObjCValue{
    union {
        Byte byteValue;
        char charValue;
        short shortValue;
        int intValue;
        long longValue;
        long long longlongValue;
        float floatValue;
        double doubleValue;
        bool boolValue;
        SEL selectorValue;
        void *pointerValue;
        void *structLocation;
        char *cStringLocation;
    };
};



@implementation NSObject (Description)

- (NSString *)otherDescription{
    NSMutableString * str=[NSMutableString string];
    
    [str appendFormat:@"%@ [",NSStringFromClass([self class])];
    Class clazz=[self class];
    unsigned int count;
    
    objc_property_t * pros=class_copyPropertyList(clazz, &count);
    for(int i=0;i<count;i++){
        if(i!=0){
            [str appendString:@", "];
        }
        objc_property_t property= pros[i];
        const char * nameChar=property_getName(property);
        NSString * name=[NSString stringWithFormat:@"%s",nameChar];
        id value = [self valueForKey:name];
        [str appendFormat:@"%@=%@",name,value];
    }
    [str appendString:@"]"];
    return str;
}

// Channel [id=1, channelName=栏目, accessPath=/user/*]
- (NSString *)myDescription
{
    NSMutableString * str=[NSMutableString string];
    
    [str appendFormat:@"%@ [",NSStringFromClass([self class])];
    Class clazz=[self class];
    unsigned int count;
    
    objc_property_t * pros=class_copyPropertyList(clazz, &count);
    for(int i=0;i<count;i++){
        if(i!=0){
            [str appendString:@", "];
        }
        objc_property_t property= pros[i];
        const char * nameChar=property_getName(property);
        NSString * name=[NSString stringWithFormat:@"%s",nameChar];
        SEL sel= NSSelectorFromString(name);
        
        NSInvocationOperation * inv= [[NSInvocationOperation alloc]initWithTarget:self selector:sel object:nil];
        [inv start];
        
        if([[inv.result class] isSubclassOfClass:[NSValue class]]){
            NSValue * value=inv.result;
            const char * c=value.objCType;
//            NSLog(@"%c",c[0]);
            [self appendWithKey:name andObjcType:c[0] andNSMutableString:str andValue:value];
//        }else if([[inv.result class] isSubclassOfClass:[NSString class]]){
//            [str appendFormat:@"%@=%@",name,inv.result];
        }else{
//            NSLog(@"%d",[[inv.result class] isSubclassOfClass:[NSb class]]);
            if(inv.result==nil){
                [str appendFormat:@"%@=%@",name,nil];
            }else{
                [str appendFormat:@"%@=%@",name,inv.result];
            }
        }
    }
    [str appendString:@"]"];
    return str;
}

- (void)appendWithKey:(NSString *)key andObjcType:(NSObjCValueType)objcType andNSMutableString:(NSMutableString *)str andValue:(NSValue *)value{
    struct NSObjCValue objc;
    if(objcType == NSObjCIntType){
        [value getValue:&(objc.intValue)];
        [str appendFormat:@"%@=%d",key,objc.intValue];
    }else if(objcType == NSObjCFloatType){
        [value getValue:&(objc.floatValue)];
        [str appendFormat:@"%@=%.5f",key,objc.floatValue];
    }else if (objcType == NSObjCCharType){
        [value getValue:&(objc.charValue)];
        [str appendFormat:@"%@=%c",key,objc.charValue];
    }else if (objcType == NSObjCShortType){
        [value getValue:&(objc.charValue)];
        [str appendFormat:@"%@=%c",key,objc.charValue];
    }else if (objcType == NSObjCLongType){
        [value getValue:&(objc.longValue)];
        [str appendFormat:@"%@=%ld",key,objc.longValue];
    }else if (objcType == NSObjCLonglongType){
        [value getValue:&(objc.longlongValue)];
        [str appendFormat:@"%@=%lld",key,objc.longlongValue];
    }else if (objcType == NSObjCDoubleType){
        [value getValue:&(objc.doubleValue)];
        [str appendFormat:@"%@=%f",key,objc.doubleValue];
    }else if (objcType == NSObjCBoolType){
        [value getValue:&(objc.boolValue)];
        [str appendFormat:@"%@=%@",key,objc.boolValue==0?@"false":@"true"];
    }else if (objcType == NSObjCByteType){
        [value getValue:&(objc.byteValue)];
        [str appendFormat:@"%@=%d",key,objc.byteValue];
    }else if (objcType == NSObjCPointerType){
        [value getValue:&(objc.pointerValue)];
        [str appendFormat:@"%@=%p",key,objc.pointerValue];
    }else if(objcType == NSObjCStringType){
        [value getValue:&(objc.cStringLocation)];
        [str appendFormat:@"%@=%s",key,objc.cStringLocation];
    }

}


@end
