From: Bret Palsson <bret@getjive.com>
Date: Mon, 12 Jan 2009 14:29:10 -0700
Subject: [Ocfs2-devel] Compiling errors: ocfs2-1.4.1 kernel version 2.6.22.19
Message-ID: <A93E3CC4-59C5-4A80-9357-598D0F0BEF85@getjive.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I'm trying to compile ocfs2-1.4.1 in on my system and it's not working
very well. This is what is happening after running the following:

Is there a patch for this? Or what could be wrong?


./configure --with-kernel=/usr/src/kernels/2.6.22.19-vs2.3.0.34.1-
x86_64 ; make

make -C fs
make[1]: Entering directory `/root/ocfs2-1.4.1/fs'
make -C ocfs2 stamp-md5
make[2]: Entering directory `/root/ocfs2-1.4.1/fs/ocfs2'
make[2]: `stamp-md5' is up to date.
make[2]: Leaving directory `/root/ocfs2-1.4.1/fs/ocfs2'
make -C ocfs2/cluster stamp-md5
make[2]: Entering directory `/root/ocfs2-1.4.1/fs/ocfs2/cluster'
make[2]: `stamp-md5' is up to date.
make[2]: Leaving directory `/root/ocfs2-1.4.1/fs/ocfs2/cluster'
make -C ocfs2/dlm stamp-md5
make[2]: Entering directory `/root/ocfs2-1.4.1/fs/ocfs2/dlm'
make[2]: `stamp-md5' is up to date.
make[2]: Leaving directory `/root/ocfs2-1.4.1/fs/ocfs2/dlm'
make -C /usr/src/kernels/2.6.22.19-vs2.3.0.34.1-x86_64 M=/root/
ocfs2-1.4.1/fs modules
make[2]: Entering directory `/usr/src/kernels/2.6.22.19-vs2.3.0.34.1-
x86_64'
   CC [M]  /root/ocfs2-1.4.1/fs/ocfs2/compat_should_remove_suid.o
In file included from /root/ocfs2-1.4.1/fs/../kapi-compat/include/
splice.h:7,
                  from <command line>:1:
include/linux/pipe_fs_i.h:20: error: expected specifier-qualifier-list
before ?wait_queue_head_t?
include/linux/pipe_fs_i.h:63: warning: ?struct inode? declared inside
parameter list
include/linux/pipe_fs_i.h:63: warning: its scope is only this
definition or declaration, which is probably not what you want
include/linux/pipe_fs_i.h:64: warning: ?struct inode? declared inside
parameter list
include/linux/pipe_fs_i.h:92: error: expected specifier-qualifier-list
before ?loff_t?
include/linux/pipe_fs_i.h:98: error: expected ?=?, ?,?, ?;?, ?asm? or
?__attribute__? before ?splice_from_pipe?
include/linux/pipe_fs_i.h:102: error: expected ?=?, ?,?, ?;?, ?asm? or
?__attribute__? before ?__splice_from_pipe?
In file included from <command line>:1:
/root/ocfs2-1.4.1/fs/../kapi-compat/include/splice.h:8: error:
expected ?=?, ?,?, ?;?, ?asm? or ?__attribute__? before
?__splice_from_pipe?
make[4]: *** [/root/ocfs2-1.4.1/fs/ocfs2/compat_should_remove_suid.o]
Error 1
make[3]: *** [/root/ocfs2-1.4.1/fs/ocfs2] Error 2
make[2]: *** [_module_/root/ocfs2-1.4.1/fs] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.22.19-vs2.3.0.34.1-
x86_64'
make[1]: *** [build-modules] Error 2
make[1]: Leaving directory `/root/ocfs2-1.4.1/fs'
make: *** [fs] Error 2



_______________________________________________
Ocfs2-users mailing list
Ocfs2-users at oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-users
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090112/a193f1f2/attachment.html 
