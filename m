From: satit pherm <satit@wbac.ac.th>
Date: Sat, 13 Feb 2010 11:39:01 +0700
Subject: [Ocfs2-devel] ocfs2 compile error in x86_64
Message-ID: <b84722ce1002122039u78453746xc66f83fdd22fa3f1@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,
I tried to compiled ocfs2 on 2.6.32.2 x86_64 but still failed.
there are an error blow:
---------------------------------------------------------------------------------------------------------------------

xattr.c: In function 'check_xattr_entry':
xattr.c:250: warning: format '%u' expects type 'unsigned int', but argument
7 has type 'long int'
xattr.c:287: warning: format '%lu' expects type 'long unsigned int', but
argument 8 has type '__u64'
gcc -m64 -O2 -Wall -Wstrict-prototypes -Wmissing-prototypes
-Wmissing-declarations -pipe  -static -o fsck.ocfs2 fsck.o dirblocks.o
dirparents.o extent.o icount.o journal.o pass0.o pass1.o pass1b.o pass2.o
pass3.o pass4.o pass5.o problem.o refcount.o slot_recovery.o strings.o
util.o xattr.o ../libocfs2/libocfs2.a ../libo2dlm/libo2dlm.a
../libo2cb/libo2cb.a -L../libocfs2 -locfs2 -L../libo2dlm -lo2dlm
-L../libo2cb -lo2cb -lcom_err
/usr/lib/gcc/x86_64-unknown-linux-gnu/4.4.1/../../../../lib/libcom_err.a(error_message.o):
In function `fini_et_lock':
/sources/e2fsprogs-1.41.9/build/lib/et/../../../lib/et/error_message.c:74:
undefined reference to `sem_destroy'
/usr/lib/gcc/x86_64-unknown-linux-gnu/4.4.1/../../../../lib/libcom_err.a(error_message.o):
In function `setup_et_lock':
/sources/e2fsprogs-1.41.9/build/lib/et/../../../lib/et/error_message.c:68:
undefined reference to `sem_init'
/usr/lib/gcc/x86_64-unknown-linux-gnu/4.4.1/../../../../lib/libcom_err.a(error_message.o):
In function `et_list_unlock':
/sources/e2fsprogs-1.41.9/build/lib/et/../../../lib/et/error_message.c:95:
undefined reference to `sem_post'
/usr/lib/gcc/x86_64-unknown-linux-gnu/4.4.1/../../../../lib/libcom_err.a(error_message.o):
In function `et_list_lock':
/sources/e2fsprogs-1.41.9/build/lib/et/../../../lib/et/error_message.c:85:
undefined reference to `sem_wait'
collect2: ld returned 1 exit status
make[1]: *** [fsck.ocfs2] Error 1
make[1]: Leaving directory `/root/localdir/fsck.ocfs2'
make: *** [fsck.ocfs2] Error 2
--------------------------------------------------------------------------------------------------------------------------
Anyone have any Idea?
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20100213/1806e232/attachment-0001.html 
