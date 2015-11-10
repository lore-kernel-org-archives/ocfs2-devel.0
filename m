From: Gang He <ghe@suse.com>
Date: Mon, 09 Nov 2015 19:07:03 -0700
Subject: [Ocfs2-devel] ocfs2-test project compile error
In-Reply-To: <CACbbJyY9at9pTA_JGoKXZi7zXwqX0MZr9jgXePDpe29WbshTsQ@mail.gmail.com>
References: <CACbbJyY9at9pTA_JGoKXZi7zXwqX0MZr9jgXePDpe29WbshTsQ@mail.gmail.com>
Message-ID: <5641C1C7020000F90001DB42@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Zhen,

I remember that you ever experienced the similar problem, could you share how to address this problem?

Thanks
Gang 


>>> 
> Hi list,
> 
> I failed to compile ocfs2 test project today after executing make as follow:
> ...
> make -C inline-data
> make[2]: Entering directory '/home/ocfs2test/ocfs2-test/programs/inline-data'
> gcc -O2 -Wall -g  -o inline-data inline-data.o inline-data-utils.o -locfs2
> /usr/lib64/gcc/x86_64-suse-linux/4.8/../../../../lib64/libocfs2.a(unix_io.o):
> In function `unix_vec_read_blocks':
> /home/abuild/rpmbuild/BUILD/ocfs2-tools-1.8.2+git.1361836695.ff84eb5/libocfs2/
> unix_io.c:177:
> undefined reference to `io_queue_release'
> /home/abuild/rpmbuild/BUILD/ocfs2-tools-1.8.2+git.1361836695.ff84eb5/libocfs2/
> unix_io.c:142:
> undefined reference to `io_queue_init'
> /home/abuild/rpmbuild/BUILD/ocfs2-tools-1.8.2+git.1361836695.ff84eb5/libocfs2/
> unix_io.c:161:
> undefined reference to `io_getevents'
> /home/abuild/rpmbuild/BUILD/ocfs2-tools-1.8.2+git.1361836695.ff84eb5/libocfs2/
> unix_io.c:154:
> undefined reference to `io_submit'
> collect2: error: ld returned 1 exit status
> Makefile:21: recipe for target 'inline-data' failed
> make[2]: *** [inline-data] Error 1
> make[2]: Leaving directory '/home/ocfs2test/ocfs2-test/programs/inline-data'
> ../Postamble.make:54: recipe for target 'inline-data' failed
> make[1]: *** [inline-data] Error 2
> make[1]: Leaving directory '/home/ocfs2test/ocfs2-test/programs'
> Postamble.make:54: recipe for target 'programs' failed
> make: *** [programs] Error 2
> ...
> 
> According to https://github.com/markfasheh/ocfs2-test/README 
> instructions but on sles12 sp1, I've installed this packages:
> i | libaio-devel  | Development Files for Linux-native Asynchronous
> I/O Access | package
> i | libaio1       | Linux-Native Asynchronous I/O Access Library
>         | package
> i | glibc               | Standard Shared Libraries (from the GNU C
> Library)    | package
> i | glibc-32bit         | Standard Shared Libraries (from the GNU C
> Library)    | package
> i | glibc-devel         | Include Files and Libraries Mandatory for
> Development | package
> i | glibc-devel-static  | C library static libraries for -static
> linking        | package
> i | e2fsprogs-devel | Dummy development package | package
> i | openmpi              | A powerful implementaion of MPI      | package
> i | openmpi-devel        | SDK for openMPI                      | package
> i | openmpi-devel-static | Static openMPI libraries             | package
> i | openmpi-libs         | OpenMPI runtime libraries            | package
> and so on...
> 
> Any other packages needed?.
> 
> -- 
> Thanks,
> Darwin
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
