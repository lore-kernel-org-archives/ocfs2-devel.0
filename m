From: kbuild test robot <lkp@intel.com>
Date: Sat, 14 Oct 2017 19:50:59 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/cluster: make config_item_type const
In-Reply-To: <1507798192-20528-1-git-send-email-bhumirks@gmail.com>
Message-ID: <201710141952.eTx63Xw9%fengguang.wu@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Bhumika,

[auto build test WARNING on linus/master]
[also build test WARNING on v4.14-rc4 next-20171013]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_0day-2Dci_linux_commits_Bhumika-2DGoyal_ocfs2-2Dcluster-2Dmake-2Dconfig-5Fitem-5Ftype-2Dconst_20171014-2D185701&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PQcxBKCX5YTpkKY057SbK10&r=f4ohdmGrYxZejY77yzx3eNgTHb1ZAfZytktjHqNVzc8&m=4fT109phFDGTzLoQ_1gyG5rGk7zpX7-tjDNQTcZkrKc&s=aoUCsoVesff8xh5AWS-g_njVmN940HU08w2FgnVWwvU&e= 
config: i386-randconfig-x008-201741 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   fs/ocfs2//cluster/heartbeat.c: In function 'o2hb_heartbeat_group_make_item':
>> fs/ocfs2//cluster/heartbeat.c:2143:50: warning: passing argument 3 of 'config_item_init_type_name' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
                                                     ^
   In file included from fs/ocfs2//cluster/heartbeat.c:32:0:
   include/linux/configfs.h:73:13: note: expected 'struct config_item_type *' but argument is of type 'const struct config_item_type *'
    extern void config_item_init_type_name(struct config_item *item,
                ^~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ocfs2//cluster/heartbeat.c: In function 'o2hb_alloc_hb_set':
>> fs/ocfs2//cluster/heartbeat.c:2331:9: warning: passing argument 3 of 'config_group_init_type_name' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
            &o2hb_heartbeat_group_type);
            ^
   In file included from fs/ocfs2//cluster/heartbeat.c:32:0:
   include/linux/configfs.h:102:13: note: expected 'struct config_item_type *' but argument is of type 'const struct config_item_type *'
    extern void config_group_init_type_name(struct config_group *group,
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:4:0,
                    from include/linux/kernel.h:6,
                    from fs/ocfs2//cluster/heartbeat.c:22:
   fs/ocfs2//cluster/heartbeat.c: At top level:
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'strcpy' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:421:2: note: in expansion of macro 'if'
     if (p_size == (size_t)-1 && q_size == (size_t)-1)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'kmemdup' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:411:2: note: in expansion of macro 'if'
     if (p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'kmemdup' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:409:2: note: in expansion of macro 'if'
     if (__builtin_constant_p(size) && p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr_inv' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:400:2: note: in expansion of macro 'if'
     if (p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr_inv' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:398:2: note: in expansion of macro 'if'
     if (__builtin_constant_p(size) && p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:389:2: note: in expansion of macro 'if'
     if (p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:387:2: note: in expansion of macro 'if'
     if (__builtin_constant_p(size) && p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:379:2: note: in expansion of macro 'if'
     if (p_size < size || q_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:376:3: note: in expansion of macro 'if'
      if (q_size < size)
      ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:374:3: note: in expansion of macro 'if'
      if (p_size < size)
      ^~
--
   fs/ocfs2//cluster/nodemanager.c: In function 'o2nm_node_group_make_item':
>> fs/ocfs2//cluster/nodemanager.c:573:51: warning: passing argument 3 of 'config_item_init_type_name' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     config_item_init_type_name(&node->nd_item, name, &o2nm_node_type);
                                                      ^
   In file included from fs/ocfs2//cluster/nodemanager.c:25:0:
   include/linux/configfs.h:73:13: note: expected 'struct config_item_type *' but argument is of type 'const struct config_item_type *'
    extern void config_item_init_type_name(struct config_item *item,
                ^~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ocfs2//cluster/nodemanager.c: In function 'o2nm_cluster_group_make_group':
>> fs/ocfs2//cluster/nodemanager.c:681:9: warning: passing argument 3 of 'config_group_init_type_name' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
            &o2nm_cluster_type);
            ^
   In file included from fs/ocfs2//cluster/nodemanager.c:25:0:
   include/linux/configfs.h:102:13: note: expected 'struct config_item_type *' but argument is of type 'const struct config_item_type *'
    extern void config_group_init_type_name(struct config_group *group,
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ocfs2//cluster/nodemanager.c:685:9: warning: passing argument 3 of 'config_group_init_type_name' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
            &o2nm_node_group_type);
            ^
   In file included from fs/ocfs2//cluster/nodemanager.c:25:0:
   include/linux/configfs.h:102:13: note: expected 'struct config_item_type *' but argument is of type 'const struct config_item_type *'
    extern void config_group_init_type_name(struct config_group *group,
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ocfs2//cluster/nodemanager.c: In function 'o2nm_depend_item':
>> fs/ocfs2//cluster/nodemanager.c:743:30: warning: passing argument 1 of 'configfs_depend_item' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     return configfs_depend_item(&o2nm_cluster_group.cs_subsys, item);
                                 ^
   In file included from fs/ocfs2//cluster/nodemanager.c:25:0:
   include/linux/configfs.h:269:5: note: expected 'struct configfs_subsystem *' but argument is of type 'const struct configfs_subsystem *'
    int configfs_depend_item(struct configfs_subsystem *subsys,
        ^~~~~~~~~~~~~~~~~~~~
   fs/ocfs2//cluster/nodemanager.c: In function 'exit_o2nm':
>> fs/ocfs2//cluster/nodemanager.c:785:32: warning: passing argument 1 of 'configfs_unregister_subsystem' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     configfs_unregister_subsystem(&o2nm_cluster_group.cs_subsys);
                                   ^
   In file included from fs/ocfs2//cluster/nodemanager.c:25:0:
   include/linux/configfs.h:253:6: note: expected 'struct configfs_subsystem *' but argument is of type 'const struct configfs_subsystem *'
    void configfs_unregister_subsystem(struct configfs_subsystem *subsys);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ocfs2//cluster/nodemanager.c: In function 'init_o2nm':
>> fs/ocfs2//cluster/nodemanager.c:808:20: warning: passing argument 1 of 'config_group_init' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     config_group_init(&o2nm_cluster_group.cs_subsys.su_group);
                       ^
   In file included from fs/ocfs2//cluster/nodemanager.c:25:0:
   include/linux/configfs.h:101:13: note: expected 'struct config_group *' but argument is of type 'const struct config_group *'
    extern void config_group_init(struct config_group *group);
                ^~~~~~~~~~~~~~~~~
   In file included from include/linux/notifier.h:13:0,
                    from include/linux/memory_hotplug.h:6,
                    from include/linux/mmzone.h:779,
                    from include/linux/gfp.h:5,
                    from include/linux/slab.h:14,
                    from fs/ocfs2//cluster/nodemanager.c:22:
>> include/linux/mutex.h:113:15: warning: passing argument 1 of '__mutex_init' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     __mutex_init((mutex), #mutex, &__key);    \
                  ^
>> fs/ocfs2//cluster/nodemanager.c:809:2: note: in expansion of macro 'mutex_init'
     mutex_init(&o2nm_cluster_group.cs_subsys.su_mutex);
     ^~~~~~~~~~
   include/linux/mutex.h:133:13: note: expected 'struct mutex *' but argument is of type 'const struct mutex *'
    extern void __mutex_init(struct mutex *lock, const char *name,
                ^~~~~~~~~~~~
>> fs/ocfs2//cluster/nodemanager.c:810:36: warning: passing argument 1 of 'configfs_register_subsystem' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     ret = configfs_register_subsystem(&o2nm_cluster_group.cs_subsys);
                                       ^
   In file included from fs/ocfs2//cluster/nodemanager.c:25:0:
   include/linux/configfs.h:252:5: note: expected 'struct configfs_subsystem *' but argument is of type 'const struct configfs_subsystem *'
    int configfs_register_subsystem(struct configfs_subsystem *subsys);
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ocfs2//cluster/nodemanager.c:820:32: warning: passing argument 1 of 'configfs_unregister_subsystem' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     configfs_unregister_subsystem(&o2nm_cluster_group.cs_subsys);
                                   ^
   In file included from fs/ocfs2//cluster/nodemanager.c:25:0:
   include/linux/configfs.h:253:6: note: expected 'struct configfs_subsystem *' but argument is of type 'const struct configfs_subsystem *'
    void configfs_unregister_subsystem(struct configfs_subsystem *subsys);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/asm-generic/bug.h:4:0,
                    from arch/x86/include/asm/bug.h:81,
                    from include/linux/bug.h:4,
                    from include/linux/mmdebug.h:4,
                    from include/linux/gfp.h:4,
                    from include/linux/slab.h:14,
                    from fs/ocfs2//cluster/nodemanager.c:22:
   fs/ocfs2//cluster/nodemanager.c: At top level:
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'strcpy' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:421:2: note: in expansion of macro 'if'
     if (p_size == (size_t)-1 && q_size == (size_t)-1)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'kmemdup' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:411:2: note: in expansion of macro 'if'
     if (p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'kmemdup' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:409:2: note: in expansion of macro 'if'
     if (__builtin_constant_p(size) && p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr_inv' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:400:2: note: in expansion of macro 'if'
     if (p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr_inv' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:398:2: note: in expansion of macro 'if'
     if (__builtin_constant_p(size) && p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:389:2: note: in expansion of macro 'if'
     if (p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:387:2: note: in expansion of macro 'if'
     if (__builtin_constant_p(size) && p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:379:2: note: in expansion of macro 'if'
     if (p_size < size || q_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:376:3: note: in expansion of macro 'if'
--
   fs/ocfs2/cluster/nodemanager.c: In function 'o2nm_node_group_make_item':
   fs/ocfs2/cluster/nodemanager.c:573:51: warning: passing argument 3 of 'config_item_init_type_name' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     config_item_init_type_name(&node->nd_item, name, &o2nm_node_type);
                                                      ^
   In file included from fs/ocfs2/cluster/nodemanager.c:25:0:
   include/linux/configfs.h:73:13: note: expected 'struct config_item_type *' but argument is of type 'const struct config_item_type *'
    extern void config_item_init_type_name(struct config_item *item,
                ^~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ocfs2/cluster/nodemanager.c: In function 'o2nm_cluster_group_make_group':
   fs/ocfs2/cluster/nodemanager.c:681:9: warning: passing argument 3 of 'config_group_init_type_name' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
            &o2nm_cluster_type);
            ^
   In file included from fs/ocfs2/cluster/nodemanager.c:25:0:
   include/linux/configfs.h:102:13: note: expected 'struct config_item_type *' but argument is of type 'const struct config_item_type *'
    extern void config_group_init_type_name(struct config_group *group,
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ocfs2/cluster/nodemanager.c:685:9: warning: passing argument 3 of 'config_group_init_type_name' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
            &o2nm_node_group_type);
            ^
   In file included from fs/ocfs2/cluster/nodemanager.c:25:0:
   include/linux/configfs.h:102:13: note: expected 'struct config_item_type *' but argument is of type 'const struct config_item_type *'
    extern void config_group_init_type_name(struct config_group *group,
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ocfs2/cluster/nodemanager.c: In function 'o2nm_depend_item':
   fs/ocfs2/cluster/nodemanager.c:743:30: warning: passing argument 1 of 'configfs_depend_item' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     return configfs_depend_item(&o2nm_cluster_group.cs_subsys, item);
                                 ^
   In file included from fs/ocfs2/cluster/nodemanager.c:25:0:
   include/linux/configfs.h:269:5: note: expected 'struct configfs_subsystem *' but argument is of type 'const struct configfs_subsystem *'
    int configfs_depend_item(struct configfs_subsystem *subsys,
        ^~~~~~~~~~~~~~~~~~~~
   fs/ocfs2/cluster/nodemanager.c: In function 'exit_o2nm':
   fs/ocfs2/cluster/nodemanager.c:785:32: warning: passing argument 1 of 'configfs_unregister_subsystem' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     configfs_unregister_subsystem(&o2nm_cluster_group.cs_subsys);
                                   ^
   In file included from fs/ocfs2/cluster/nodemanager.c:25:0:
   include/linux/configfs.h:253:6: note: expected 'struct configfs_subsystem *' but argument is of type 'const struct configfs_subsystem *'
    void configfs_unregister_subsystem(struct configfs_subsystem *subsys);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ocfs2/cluster/nodemanager.c: In function 'init_o2nm':
   fs/ocfs2/cluster/nodemanager.c:808:20: warning: passing argument 1 of 'config_group_init' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     config_group_init(&o2nm_cluster_group.cs_subsys.su_group);
                       ^
   In file included from fs/ocfs2/cluster/nodemanager.c:25:0:
   include/linux/configfs.h:101:13: note: expected 'struct config_group *' but argument is of type 'const struct config_group *'
    extern void config_group_init(struct config_group *group);
                ^~~~~~~~~~~~~~~~~
   In file included from include/linux/notifier.h:13:0,
                    from include/linux/memory_hotplug.h:6,
                    from include/linux/mmzone.h:779,
                    from include/linux/gfp.h:5,
                    from include/linux/slab.h:14,
                    from fs/ocfs2/cluster/nodemanager.c:22:
>> include/linux/mutex.h:113:15: warning: passing argument 1 of '__mutex_init' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     __mutex_init((mutex), #mutex, &__key);    \
                  ^
   fs/ocfs2/cluster/nodemanager.c:809:2: note: in expansion of macro 'mutex_init'
     mutex_init(&o2nm_cluster_group.cs_subsys.su_mutex);
     ^~~~~~~~~~
   include/linux/mutex.h:133:13: note: expected 'struct mutex *' but argument is of type 'const struct mutex *'
    extern void __mutex_init(struct mutex *lock, const char *name,
                ^~~~~~~~~~~~
   fs/ocfs2/cluster/nodemanager.c:810:36: warning: passing argument 1 of 'configfs_register_subsystem' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     ret = configfs_register_subsystem(&o2nm_cluster_group.cs_subsys);
                                       ^
   In file included from fs/ocfs2/cluster/nodemanager.c:25:0:
   include/linux/configfs.h:252:5: note: expected 'struct configfs_subsystem *' but argument is of type 'const struct configfs_subsystem *'
    int configfs_register_subsystem(struct configfs_subsystem *subsys);
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ocfs2/cluster/nodemanager.c:820:32: warning: passing argument 1 of 'configfs_unregister_subsystem' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     configfs_unregister_subsystem(&o2nm_cluster_group.cs_subsys);
                                   ^
   In file included from fs/ocfs2/cluster/nodemanager.c:25:0:
   include/linux/configfs.h:253:6: note: expected 'struct configfs_subsystem *' but argument is of type 'const struct configfs_subsystem *'
    void configfs_unregister_subsystem(struct configfs_subsystem *subsys);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/asm-generic/bug.h:4:0,
                    from arch/x86/include/asm/bug.h:81,
                    from include/linux/bug.h:4,
                    from include/linux/mmdebug.h:4,
                    from include/linux/gfp.h:4,
                    from include/linux/slab.h:14,
                    from fs/ocfs2/cluster/nodemanager.c:22:
   fs/ocfs2/cluster/nodemanager.c: At top level:
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'strcpy' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:421:2: note: in expansion of macro 'if'
     if (p_size == (size_t)-1 && q_size == (size_t)-1)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'kmemdup' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:411:2: note: in expansion of macro 'if'
     if (p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'kmemdup' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:409:2: note: in expansion of macro 'if'
     if (__builtin_constant_p(size) && p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr_inv' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:400:2: note: in expansion of macro 'if'
     if (p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr_inv' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:398:2: note: in expansion of macro 'if'
     if (__builtin_constant_p(size) && p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:389:2: note: in expansion of macro 'if'
     if (p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:387:2: note: in expansion of macro 'if'
     if (__builtin_constant_p(size) && p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:379:2: note: in expansion of macro 'if'

vim +2143 fs/ocfs2//cluster/heartbeat.c

1f28530537 Sunil Mushran     2010-10-06  2112  
f89ab8619e Joel Becker       2008-07-17  2113  static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *group,
f89ab8619e Joel Becker       2008-07-17  2114  							  const char *name)
a7f6a5fb4b Mark Fasheh       2005-12-15  2115  {
a7f6a5fb4b Mark Fasheh       2005-12-15  2116  	struct o2hb_region *reg = NULL;
1f28530537 Sunil Mushran     2010-10-06  2117  	int ret;
a7f6a5fb4b Mark Fasheh       2005-12-15  2118  
cd86128088 Robert P. J. Day  2006-12-13  2119  	reg = kzalloc(sizeof(struct o2hb_region), GFP_KERNEL);
f89ab8619e Joel Becker       2008-07-17  2120  	if (reg == NULL)
a6795e9ebb Joel Becker       2008-07-17  2121  		return ERR_PTR(-ENOMEM);
a7f6a5fb4b Mark Fasheh       2005-12-15  2122  
1cf257f511 Jiri Slaby        2010-11-06  2123  	if (strlen(name) > O2HB_MAX_REGION_NAME_LEN) {
1cf257f511 Jiri Slaby        2010-11-06  2124  		ret = -ENAMETOOLONG;
1cf257f511 Jiri Slaby        2010-11-06  2125  		goto free;
1cf257f511 Jiri Slaby        2010-11-06  2126  	}
b3c85c4cdf Sunil Mushran     2010-10-07  2127  
a7f6a5fb4b Mark Fasheh       2005-12-15  2128  	spin_lock(&o2hb_live_lock);
536f0741f3 Sunil Mushran     2010-10-07  2129  	reg->hr_region_num = 0;
536f0741f3 Sunil Mushran     2010-10-07  2130  	if (o2hb_global_heartbeat_active()) {
536f0741f3 Sunil Mushran     2010-10-07  2131  		reg->hr_region_num = find_first_zero_bit(o2hb_region_bitmap,
536f0741f3 Sunil Mushran     2010-10-07  2132  							 O2NM_MAX_REGIONS);
536f0741f3 Sunil Mushran     2010-10-07  2133  		if (reg->hr_region_num >= O2NM_MAX_REGIONS) {
536f0741f3 Sunil Mushran     2010-10-07  2134  			spin_unlock(&o2hb_live_lock);
1cf257f511 Jiri Slaby        2010-11-06  2135  			ret = -EFBIG;
1cf257f511 Jiri Slaby        2010-11-06  2136  			goto free;
536f0741f3 Sunil Mushran     2010-10-07  2137  		}
536f0741f3 Sunil Mushran     2010-10-07  2138  		set_bit(reg->hr_region_num, o2hb_region_bitmap);
536f0741f3 Sunil Mushran     2010-10-07  2139  	}
a7f6a5fb4b Mark Fasheh       2005-12-15  2140  	list_add_tail(&reg->hr_all_item, &o2hb_all_regions);
a7f6a5fb4b Mark Fasheh       2005-12-15  2141  	spin_unlock(&o2hb_live_lock);
a7f6a5fb4b Mark Fasheh       2005-12-15  2142  
536f0741f3 Sunil Mushran     2010-10-07 @2143  	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
536f0741f3 Sunil Mushran     2010-10-07  2144  
34069b886f Junxiao Bi        2016-05-27  2145  	/* this is the same way to generate msg key as dlm, for local heartbeat,
34069b886f Junxiao Bi        2016-05-27  2146  	 * name is also the same, so make initial crc value different to avoid
34069b886f Junxiao Bi        2016-05-27  2147  	 * message key conflict.
34069b886f Junxiao Bi        2016-05-27  2148  	 */
34069b886f Junxiao Bi        2016-05-27  2149  	reg->hr_key = crc32_le(reg->hr_region_num + O2NM_MAX_REGIONS,
34069b886f Junxiao Bi        2016-05-27  2150  		name, strlen(name));
34069b886f Junxiao Bi        2016-05-27  2151  	INIT_LIST_HEAD(&reg->hr_handler_list);
34069b886f Junxiao Bi        2016-05-27  2152  	ret = o2net_register_handler(O2HB_NEGO_TIMEOUT_MSG, reg->hr_key,
34069b886f Junxiao Bi        2016-05-27  2153  			sizeof(struct o2hb_nego_msg),
34069b886f Junxiao Bi        2016-05-27  2154  			o2hb_nego_timeout_handler,
34069b886f Junxiao Bi        2016-05-27  2155  			reg, NULL, &reg->hr_handler_list);
34069b886f Junxiao Bi        2016-05-27  2156  	if (ret)
34069b886f Junxiao Bi        2016-05-27  2157  		goto free;
34069b886f Junxiao Bi        2016-05-27  2158  
e76f8237a2 Junxiao Bi        2016-05-27  2159  	ret = o2net_register_handler(O2HB_NEGO_APPROVE_MSG, reg->hr_key,
e76f8237a2 Junxiao Bi        2016-05-27  2160  			sizeof(struct o2hb_nego_msg),
e76f8237a2 Junxiao Bi        2016-05-27  2161  			o2hb_nego_approve_handler,
e76f8237a2 Junxiao Bi        2016-05-27  2162  			reg, NULL, &reg->hr_handler_list);
e76f8237a2 Junxiao Bi        2016-05-27  2163  	if (ret)
e76f8237a2 Junxiao Bi        2016-05-27  2164  		goto unregister_handler;
e76f8237a2 Junxiao Bi        2016-05-27  2165  
1f28530537 Sunil Mushran     2010-10-06  2166  	ret = o2hb_debug_region_init(reg, o2hb_debug_dir);
1f28530537 Sunil Mushran     2010-10-06  2167  	if (ret) {
1f28530537 Sunil Mushran     2010-10-06  2168  		config_item_put(&reg->hr_item);
34069b886f Junxiao Bi        2016-05-27  2169  		goto unregister_handler;
1f28530537 Sunil Mushran     2010-10-06  2170  	}
1f28530537 Sunil Mushran     2010-10-06  2171  
a6795e9ebb Joel Becker       2008-07-17  2172  	return &reg->hr_item;
34069b886f Junxiao Bi        2016-05-27  2173  
34069b886f Junxiao Bi        2016-05-27  2174  unregister_handler:
34069b886f Junxiao Bi        2016-05-27  2175  	o2net_unregister_handler_list(&reg->hr_handler_list);
1cf257f511 Jiri Slaby        2010-11-06  2176  free:
1cf257f511 Jiri Slaby        2010-11-06  2177  	kfree(reg);
1cf257f511 Jiri Slaby        2010-11-06  2178  	return ERR_PTR(ret);
a7f6a5fb4b Mark Fasheh       2005-12-15  2179  }
a7f6a5fb4b Mark Fasheh       2005-12-15  2180  
a7f6a5fb4b Mark Fasheh       2005-12-15  2181  static void o2hb_heartbeat_group_drop_item(struct config_group *group,
a7f6a5fb4b Mark Fasheh       2005-12-15  2182  					   struct config_item *item)
a7f6a5fb4b Mark Fasheh       2005-12-15  2183  {
e6c352dbc0 Joel Becker       2007-02-03  2184  	struct task_struct *hb_task;
a7f6a5fb4b Mark Fasheh       2005-12-15  2185  	struct o2hb_region *reg = to_o2hb_region(item);
58a3158a5d Sunil Mushran     2010-12-14  2186  	int quorum_region = 0;
a7f6a5fb4b Mark Fasheh       2005-12-15  2187  
a7f6a5fb4b Mark Fasheh       2005-12-15  2188  	/* stop the thread when the user removes the region dir */
e6c352dbc0 Joel Becker       2007-02-03  2189  	spin_lock(&o2hb_live_lock);
e6c352dbc0 Joel Becker       2007-02-03  2190  	hb_task = reg->hr_task;
a7f6a5fb4b Mark Fasheh       2005-12-15  2191  	reg->hr_task = NULL;
58a3158a5d Sunil Mushran     2010-12-14  2192  	reg->hr_item_dropped = 1;
e6c352dbc0 Joel Becker       2007-02-03  2193  	spin_unlock(&o2hb_live_lock);
e6c352dbc0 Joel Becker       2007-02-03  2194  
e6c352dbc0 Joel Becker       2007-02-03  2195  	if (hb_task)
e6c352dbc0 Joel Becker       2007-02-03  2196  		kthread_stop(hb_task);
a7f6a5fb4b Mark Fasheh       2005-12-15  2197  
d2eece3766 Sunil Mushran     2011-07-24  2198  	if (o2hb_global_heartbeat_active()) {
d2eece3766 Sunil Mushran     2011-07-24  2199  		spin_lock(&o2hb_live_lock);
d2eece3766 Sunil Mushran     2011-07-24  2200  		clear_bit(reg->hr_region_num, o2hb_region_bitmap);
d2eece3766 Sunil Mushran     2011-07-24  2201  		clear_bit(reg->hr_region_num, o2hb_live_region_bitmap);
d2eece3766 Sunil Mushran     2011-07-24  2202  		if (test_bit(reg->hr_region_num, o2hb_quorum_region_bitmap))
d2eece3766 Sunil Mushran     2011-07-24  2203  			quorum_region = 1;
d2eece3766 Sunil Mushran     2011-07-24  2204  		clear_bit(reg->hr_region_num, o2hb_quorum_region_bitmap);
d2eece3766 Sunil Mushran     2011-07-24  2205  		spin_unlock(&o2hb_live_lock);
d2eece3766 Sunil Mushran     2011-07-24  2206  		printk(KERN_NOTICE "o2hb: Heartbeat %s on region %s (%s)\n",
d2eece3766 Sunil Mushran     2011-07-24  2207  		       ((atomic_read(&reg->hr_steady_iterations) == 0) ?
d2eece3766 Sunil Mushran     2011-07-24  2208  			"stopped" : "start aborted"), config_item_name(item),
d2eece3766 Sunil Mushran     2011-07-24  2209  		       reg->hr_dev_name);
d2eece3766 Sunil Mushran     2011-07-24  2210  	}
d2eece3766 Sunil Mushran     2011-07-24  2211  
e6df3a663a Joel Becker       2007-02-06  2212  	/*
e6df3a663a Joel Becker       2007-02-06  2213  	 * If we're racing a dev_write(), we need to wake them.  They will
e6df3a663a Joel Becker       2007-02-06  2214  	 * check reg->hr_task
e6df3a663a Joel Becker       2007-02-06  2215  	 */
e6df3a663a Joel Becker       2007-02-06  2216  	if (atomic_read(&reg->hr_steady_iterations) != 0) {
d2eece3766 Sunil Mushran     2011-07-24  2217  		reg->hr_aborted_start = 1;
e6df3a663a Joel Becker       2007-02-06  2218  		atomic_set(&reg->hr_steady_iterations, 0);
e6df3a663a Joel Becker       2007-02-06  2219  		wake_up(&o2hb_steady_queue);
e6df3a663a Joel Becker       2007-02-06  2220  	}
e6df3a663a Joel Becker       2007-02-06  2221  
a7f6a5fb4b Mark Fasheh       2005-12-15  2222  	config_item_put(item);
58a3158a5d Sunil Mushran     2010-12-14  2223  
58a3158a5d Sunil Mushran     2010-12-14  2224  	if (!o2hb_global_heartbeat_active() || !quorum_region)
58a3158a5d Sunil Mushran     2010-12-14  2225  		return;
58a3158a5d Sunil Mushran     2010-12-14  2226  
58a3158a5d Sunil Mushran     2010-12-14  2227  	/*
58a3158a5d Sunil Mushran     2010-12-14  2228  	 * If global heartbeat active and there are dependent users,
58a3158a5d Sunil Mushran     2010-12-14  2229  	 * pin all regions if quorum region count <= CUT_OFF
58a3158a5d Sunil Mushran     2010-12-14  2230  	 */
58a3158a5d Sunil Mushran     2010-12-14  2231  	spin_lock(&o2hb_live_lock);
58a3158a5d Sunil Mushran     2010-12-14  2232  
58a3158a5d Sunil Mushran     2010-12-14  2233  	if (!o2hb_dependent_users)
58a3158a5d Sunil Mushran     2010-12-14  2234  		goto unlock;
58a3158a5d Sunil Mushran     2010-12-14  2235  
a8f70de37b Akinobu Mita      2013-11-12  2236  	if (bitmap_weight(o2hb_quorum_region_bitmap,
58a3158a5d Sunil Mushran     2010-12-14  2237  			   O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF)
58a3158a5d Sunil Mushran     2010-12-14  2238  		o2hb_region_pin(NULL);
58a3158a5d Sunil Mushran     2010-12-14  2239  
58a3158a5d Sunil Mushran     2010-12-14  2240  unlock:
58a3158a5d Sunil Mushran     2010-12-14  2241  	spin_unlock(&o2hb_live_lock);
a7f6a5fb4b Mark Fasheh       2005-12-15  2242  }
a7f6a5fb4b Mark Fasheh       2005-12-15  2243  
33496c3c3d Junxiao Bi        2017-05-03  2244  static ssize_t o2hb_heartbeat_group_dead_threshold_show(struct config_item *item,
a7f6a5fb4b Mark Fasheh       2005-12-15  2245  		char *page)
a7f6a5fb4b Mark Fasheh       2005-12-15  2246  {
a7f6a5fb4b Mark Fasheh       2005-12-15  2247  	return sprintf(page, "%u\n", o2hb_dead_threshold);
a7f6a5fb4b Mark Fasheh       2005-12-15  2248  }
a7f6a5fb4b Mark Fasheh       2005-12-15  2249  
33496c3c3d Junxiao Bi        2017-05-03  2250  static ssize_t o2hb_heartbeat_group_dead_threshold_store(struct config_item *item,
45b997737a Christoph Hellwig 2015-10-03  2251  		const char *page, size_t count)
a7f6a5fb4b Mark Fasheh       2005-12-15  2252  {
a7f6a5fb4b Mark Fasheh       2005-12-15  2253  	unsigned long tmp;
a7f6a5fb4b Mark Fasheh       2005-12-15  2254  	char *p = (char *)page;
a7f6a5fb4b Mark Fasheh       2005-12-15  2255  
a7f6a5fb4b Mark Fasheh       2005-12-15  2256  	tmp = simple_strtoul(p, &p, 10);
a7f6a5fb4b Mark Fasheh       2005-12-15  2257  	if (!p || (*p && (*p != '\n')))
a7f6a5fb4b Mark Fasheh       2005-12-15  2258                  return -EINVAL;
a7f6a5fb4b Mark Fasheh       2005-12-15  2259  
a7f6a5fb4b Mark Fasheh       2005-12-15  2260  	/* this will validate ranges for us. */
a7f6a5fb4b Mark Fasheh       2005-12-15  2261  	o2hb_dead_threshold_set((unsigned int) tmp);
a7f6a5fb4b Mark Fasheh       2005-12-15  2262  
a7f6a5fb4b Mark Fasheh       2005-12-15  2263  	return count;
a7f6a5fb4b Mark Fasheh       2005-12-15  2264  }
a7f6a5fb4b Mark Fasheh       2005-12-15  2265  
45b997737a Christoph Hellwig 2015-10-03  2266  static ssize_t o2hb_heartbeat_group_mode_show(struct config_item *item,
54b5187b5a Sunil Mushran     2010-10-07  2267  		char *page)
54b5187b5a Sunil Mushran     2010-10-07  2268  {
54b5187b5a Sunil Mushran     2010-10-07  2269  	return sprintf(page, "%s\n",
54b5187b5a Sunil Mushran     2010-10-07  2270  		       o2hb_heartbeat_mode_desc[o2hb_heartbeat_mode]);
54b5187b5a Sunil Mushran     2010-10-07  2271  }
54b5187b5a Sunil Mushran     2010-10-07  2272  
45b997737a Christoph Hellwig 2015-10-03  2273  static ssize_t o2hb_heartbeat_group_mode_store(struct config_item *item,
54b5187b5a Sunil Mushran     2010-10-07  2274  		const char *page, size_t count)
54b5187b5a Sunil Mushran     2010-10-07  2275  {
54b5187b5a Sunil Mushran     2010-10-07  2276  	unsigned int i;
54b5187b5a Sunil Mushran     2010-10-07  2277  	int ret;
54b5187b5a Sunil Mushran     2010-10-07  2278  	size_t len;
54b5187b5a Sunil Mushran     2010-10-07  2279  
54b5187b5a Sunil Mushran     2010-10-07  2280  	len = (page[count - 1] == '\n') ? count - 1 : count;
54b5187b5a Sunil Mushran     2010-10-07  2281  	if (!len)
54b5187b5a Sunil Mushran     2010-10-07  2282  		return -EINVAL;
54b5187b5a Sunil Mushran     2010-10-07  2283  
54b5187b5a Sunil Mushran     2010-10-07  2284  	for (i = 0; i < O2HB_HEARTBEAT_NUM_MODES; ++i) {
2bd63329cb Rasmus Villemoes  2014-10-13  2285  		if (strncasecmp(page, o2hb_heartbeat_mode_desc[i], len))
54b5187b5a Sunil Mushran     2010-10-07  2286  			continue;
54b5187b5a Sunil Mushran     2010-10-07  2287  
70f651edb7 Jie Liu           2013-07-03  2288  		ret = o2hb_global_heartbeat_mode_set(i);
54b5187b5a Sunil Mushran     2010-10-07  2289  		if (!ret)
18c50cb0d3 Sunil Mushran     2010-10-06  2290  			printk(KERN_NOTICE "o2hb: Heartbeat mode set to %s\n",
54b5187b5a Sunil Mushran     2010-10-07  2291  			       o2hb_heartbeat_mode_desc[i]);
54b5187b5a Sunil Mushran     2010-10-07  2292  		return count;
54b5187b5a Sunil Mushran     2010-10-07  2293  	}
54b5187b5a Sunil Mushran     2010-10-07  2294  
54b5187b5a Sunil Mushran     2010-10-07  2295  	return -EINVAL;
54b5187b5a Sunil Mushran     2010-10-07  2296  
54b5187b5a Sunil Mushran     2010-10-07  2297  }
54b5187b5a Sunil Mushran     2010-10-07  2298  
33496c3c3d Junxiao Bi        2017-05-03  2299  CONFIGFS_ATTR(o2hb_heartbeat_group_, dead_threshold);
45b997737a Christoph Hellwig 2015-10-03  2300  CONFIGFS_ATTR(o2hb_heartbeat_group_, mode);
54b5187b5a Sunil Mushran     2010-10-07  2301  
a7f6a5fb4b Mark Fasheh       2005-12-15  2302  static struct configfs_attribute *o2hb_heartbeat_group_attrs[] = {
33496c3c3d Junxiao Bi        2017-05-03  2303  	&o2hb_heartbeat_group_attr_dead_threshold,
45b997737a Christoph Hellwig 2015-10-03  2304  	&o2hb_heartbeat_group_attr_mode,
a7f6a5fb4b Mark Fasheh       2005-12-15  2305  	NULL,
a7f6a5fb4b Mark Fasheh       2005-12-15  2306  };
a7f6a5fb4b Mark Fasheh       2005-12-15  2307  
a7f6a5fb4b Mark Fasheh       2005-12-15  2308  static struct configfs_group_operations o2hb_heartbeat_group_group_ops = {
a7f6a5fb4b Mark Fasheh       2005-12-15  2309  	.make_item	= o2hb_heartbeat_group_make_item,
a7f6a5fb4b Mark Fasheh       2005-12-15  2310  	.drop_item	= o2hb_heartbeat_group_drop_item,
a7f6a5fb4b Mark Fasheh       2005-12-15  2311  };
a7f6a5fb4b Mark Fasheh       2005-12-15  2312  
6c56d97a81 Bhumika Goyal     2017-10-12  2313  static const struct config_item_type o2hb_heartbeat_group_type = {
a7f6a5fb4b Mark Fasheh       2005-12-15  2314  	.ct_group_ops	= &o2hb_heartbeat_group_group_ops,
a7f6a5fb4b Mark Fasheh       2005-12-15  2315  	.ct_attrs	= o2hb_heartbeat_group_attrs,
a7f6a5fb4b Mark Fasheh       2005-12-15  2316  	.ct_owner	= THIS_MODULE,
a7f6a5fb4b Mark Fasheh       2005-12-15  2317  };
a7f6a5fb4b Mark Fasheh       2005-12-15  2318  
a7f6a5fb4b Mark Fasheh       2005-12-15  2319  /* this is just here to avoid touching group in heartbeat.h which the
a7f6a5fb4b Mark Fasheh       2005-12-15  2320   * entire damn world #includes */
a7f6a5fb4b Mark Fasheh       2005-12-15  2321  struct config_group *o2hb_alloc_hb_set(void)
a7f6a5fb4b Mark Fasheh       2005-12-15  2322  {
a7f6a5fb4b Mark Fasheh       2005-12-15  2323  	struct o2hb_heartbeat_group *hs = NULL;
a7f6a5fb4b Mark Fasheh       2005-12-15  2324  	struct config_group *ret = NULL;
a7f6a5fb4b Mark Fasheh       2005-12-15  2325  
cd86128088 Robert P. J. Day  2006-12-13  2326  	hs = kzalloc(sizeof(struct o2hb_heartbeat_group), GFP_KERNEL);
a7f6a5fb4b Mark Fasheh       2005-12-15  2327  	if (hs == NULL)
a7f6a5fb4b Mark Fasheh       2005-12-15  2328  		goto out;
a7f6a5fb4b Mark Fasheh       2005-12-15  2329  
a7f6a5fb4b Mark Fasheh       2005-12-15  2330  	config_group_init_type_name(&hs->hs_group, "heartbeat",
a7f6a5fb4b Mark Fasheh       2005-12-15 @2331  				    &o2hb_heartbeat_group_type);
a7f6a5fb4b Mark Fasheh       2005-12-15  2332  
a7f6a5fb4b Mark Fasheh       2005-12-15  2333  	ret = &hs->hs_group;
a7f6a5fb4b Mark Fasheh       2005-12-15  2334  out:
a7f6a5fb4b Mark Fasheh       2005-12-15  2335  	if (ret == NULL)
a7f6a5fb4b Mark Fasheh       2005-12-15  2336  		kfree(hs);
a7f6a5fb4b Mark Fasheh       2005-12-15  2337  	return ret;
a7f6a5fb4b Mark Fasheh       2005-12-15  2338  }
a7f6a5fb4b Mark Fasheh       2005-12-15  2339  

:::::: The code at line 2143 was first introduced by commit
:::::: 536f0741f324f116d8b059295999945a2dac56bc ocfs2/cluster: Track number of global heartbeat regions

:::::: TO: Sunil Mushran <sunil.mushran@oracle.com>
:::::: CC: Sunil Mushran <sunil.mushran@oracle.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://urldefense.proofpoint.com/v2/url?u=https-3A__lists.01.org_pipermail_kbuild-2Dall&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PQcxBKCX5YTpkKY057SbK10&r=f4ohdmGrYxZejY77yzx3eNgTHb1ZAfZytktjHqNVzc8&m=4fT109phFDGTzLoQ_1gyG5rGk7zpX7-tjDNQTcZkrKc&s=0iAysGyxLCP7flEayj1jzxqKNSV-oAvwJucyPl1UwC4&e=                    Intel Corporation
-------------- next part --------------
A non-text attachment was scrubbed...
Name: .config.gz
Type: application/gzip
Size: 30338 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20171014/f76bb218/attachment-0001.bin 
