From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 26 Dec 2008 15:04:39 -0800
Subject: [Ocfs2-devel] [PATCH] debugfs.ocfs2: Allow dumping dlm locks
	from a file
In-Reply-To: <20081226223904.GF17410@wotan.suse.de>
References: <20081205061450.GJ8791@wotan.suse.de>
	<20081226223904.GF17410@wotan.suse.de>
Message-ID: <B51CE75C-A7AA-4D96-AEE0-86E0F65BE825@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I thought Tao had sob-ed it.

On Dec 26, 2008, at 2:39 PM, Mark Fasheh <mfasheh@suse.com> wrote:

> Anyone get a chance to sob this? It's pretty much a copy of the fs  
> locks
> patch...
>    --Mark
>
> On Thu, Dec 04, 2008 at 10:14:50PM -0800, Mark Fasheh wrote:
>> This way we can review locking state even if all a customer  
>> provides us is
>> the contents of /sys/kernel/debug/o2dlm/locking_state.
>>
>> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
>> ---
>> debugfs.ocfs2/commands.c               |   36 +++++++++++++++++++++ 
>> +-------
>> debugfs.ocfs2/dump_dlm_locks.c         |   38 +++++++++++++++++++ 
>> +-----------
>> debugfs.ocfs2/include/dump_dlm_locks.h |    2 +-
>> 3 files changed, 52 insertions(+), 24 deletions(-)
>>
>> diff --git a/debugfs.ocfs2/commands.c b/debugfs.ocfs2/commands.c
>> index 0e46151..06b6c98 100644
>> --- a/debugfs.ocfs2/commands.c
>> +++ b/debugfs.ocfs2/commands.c
>> @@ -831,7 +831,7 @@ static void do_help (char **args)
>>    printf ("controld dump\t\t\tObtain information from  
>> ocfs2_controld\n");
>>    printf ("curdev\t\t\t\t\tShow current device\n");
>>    printf ("decode <lockname#> ...\t\t\tDecode block#(s) from the  
>> lockname(s)\n");
>> -    printf ("dlm_locks [-l] lockname\t\t\tShow live dlm locking  
>> state\n");
>> +    printf ("dlm_locks [-f <file>] [-l] lockname\t\t\tShow live  
>> dlm locking state\n");
>>    printf ("dump [-p] <filespec> <outfile>\t\tDumps file to outfile  
>> on a mounted fs\n");
>>    printf ("encode <filespec>\t\t\tShow lock name\n");
>>    printf ("extent <block#>\t\t\t\tShow extent block\n");
>> @@ -1485,26 +1485,44 @@ static void do_dlm_locks(char **args)
>>    int dump_lvbs = 0;
>>    int i;
>>    struct list_head locklist;
>> -
>> -    if (check_device_open())
>> -        return;
>> +    char *path = NULL, *uuid_str = NULL;
>> +    int c, argc;
>>
>>    init_stringlist(&locklist);
>>
>> -    i = 1;
>> -    if (args[i] && strlen(args[i])) {
>> -        if (!strcmp("-l", args[i])) {
>> +    for (argc = 0; (args[argc]); ++argc);
>> +    optind = 0;
>> +
>> +    while ((c = getopt(argc, args, "lf:")) != -1) {
>> +        switch (c) {
>> +        case 'l':
>>            dump_lvbs = 1;
>> -            i++;
>> +            break;
>> +        case 'f':
>> +            path = optarg;
>> +            break;
>> +        default:
>> +            break;
>>        }
>> +    }
>> +    if ((path == NULL)) {
>> +        /* Only error for a missing device if we're asked to
>> +         * read from a live file system. */
>> +        if (check_device_open())
>> +            return;
>> +
>> +        uuid_str = gbls.fs->uuid_str;
>> +    }
>>
>> +    i = optind;
>> +    if (args[i] && strlen(args[i])) {
>>        for ( ; args[i] && strlen(args[i]); ++i)
>>            if (add_to_stringlist(args[i], &locklist))
>>                break;
>>    }
>>
>>    out = open_pager(gbls.interactive);
>> -    dump_dlm_locks(gbls.fs->uuid_str, out, dump_lvbs, &locklist);
>> +    dump_dlm_locks(uuid_str, out, path, dump_lvbs, &locklist);
>>    close_pager(out);
>>
>>    free_stringlist(&locklist);
>> diff --git a/debugfs.ocfs2/dump_dlm_locks.c b/debugfs.ocfs2/ 
>> dump_dlm_locks.c
>> index b946821..6344ff1 100644
>> --- a/debugfs.ocfs2/dump_dlm_locks.c
>> +++ b/debugfs.ocfs2/dump_dlm_locks.c
>> @@ -411,7 +411,7 @@ static int get_next_dlm_lockname(FILE *file,  
>> char *name, int len)
>>    return 0;
>> }
>>
>> -void dump_dlm_locks(char *uuid, FILE *out, int dump_lvbs,
>> +void dump_dlm_locks(char *uuid, FILE *out, char *path, int  
>> dump_lvbs,
>>            struct list_head *locklist)
>> {
>>    errcode_t ret;
>> @@ -421,20 +421,30 @@ void dump_dlm_locks(char *uuid, FILE *out,  
>> int dump_lvbs,
>>    struct lockres res;
>>    int show_all_locks = 0;
>>
>> -    ret = get_debugfs_path(debugfs_path, sizeof(debugfs_path));
>> -    if (ret) {
>> -        fprintf(stderr, "Could not locate debugfs file system. "
>> -            "Perhaps it is not mounted?\n");
>> -        return;
>> -    }
>> +    if (path == NULL) {
>> +        ret = get_debugfs_path(debugfs_path, sizeof(debugfs_path));
>> +        if (ret) {
>> +            fprintf(stderr, "Could not locate debugfs file system. "
>> +                "Perhaps it is not mounted?\n");
>> +            return;
>> +        }
>>
>> -    ret = open_debugfs_file(debugfs_path, "o2dlm", uuid,  
>> "locking_state",
>> -                &file);
>> -    if (ret) {
>> -        fprintf(stderr, "Could not open debug state for \"%s\".\n"
>> -            "Perhaps that OCFS2 file system is not mounted?\n",
>> -            uuid);
>> -        return;
>> +        ret = open_debugfs_file(debugfs_path, "o2dlm", uuid,
>> +                    "locking_state", &file);
>> +        if (ret) {
>> +            fprintf(stderr,
>> +                "Could not open debug state for \"%s\".\n"
>> +                "Perhaps that OCFS2 file system is not mounted?\n",
>> +                uuid);
>> +            return;
>> +        }
>> +    } else {
>> +        file = fopen(path, "r");
>> +        if (!file) {
>> +            fprintf(stderr, "Could not open file at \"%s\"\n",
>> +                path);
>> +            return;
>> +        }
>>    }
>>
>>    show_all_locks = list_empty(locklist);
>> diff --git a/debugfs.ocfs2/include/dump_dlm_locks.h b/debugfs.ocfs2/ 
>> include/dump_dlm_locks.h
>> index 2cbb72a..7bc35ba 100644
>> --- a/debugfs.ocfs2/include/dump_dlm_locks.h
>> +++ b/debugfs.ocfs2/include/dump_dlm_locks.h
>> @@ -74,7 +74,7 @@ struct lock {
>>    struct list_head list;
>> };
>>
>> -void dump_dlm_locks(char *uuid, FILE *out, int dump_lvbs,
>> +void dump_dlm_locks(char *uuid, FILE *out, char *path, int  
>> dump_lvbs,
>>            struct list_head *locklist);
>>
>> #endif        /* _DUMP_DLM_LOCKS_H_ */
>> -- 
>> 1.6.0.2
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> --
> Mark Fasheh
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
