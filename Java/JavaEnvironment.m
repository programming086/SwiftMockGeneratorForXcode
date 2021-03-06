#import "JavaEnvironment.h"
#import "jni.h"

static JavaVM* jvm = NULL; // Cannot recreate a JVM. See http://bugs.java.com/bugdatabase/view_bug.do?bug_id=4712793

@implementation JavaEnvironment {
    JNIEnv* env;
    JavaVMInitArgs args;
    JavaVMOption options[1];
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        
        jint version = JNI_VERSION_1_8;
        if (jvm == NULL) {
            // <- Add breakpoint here to run 'pr h -s false SIGSEGV'. See https://github.com/SwiftJava/SwiftJava
            NSString *classpath = [[NSBundle bundleForClass:[self class]] pathForResource:@"MockGeneratorUseCases" ofType:@"jar"];
            classpath = [@"-Djava.class.path=" stringByAppendingString:classpath];
            args.version = version;
            args.nOptions = 1;
            options[0].optionString = (char *)classpath.UTF8String;
            args.options = options;
            args.ignoreUnrecognized = JNI_FALSE;
            JNI_CreateJavaVM(&jvm, (void **)&env, &args);
        } else {
            (*jvm)->AttachCurrentThread(jvm, (void **)&env, NULL);
        }
    }
    return self;
}

- (void)dealloc {
    (*jvm)->DetachCurrentThread(jvm);
}

- (JNIEnv *)env {
    return env;
}


@end
