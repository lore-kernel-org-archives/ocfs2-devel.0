From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Wed Aug 11 14:48:28 2004
Subject: [Ocfs2-devel] posix / performance
Message-ID: <3ACA40606221794F80A5670F0AF15F8405251CD7@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: ocfs2-devel@oss.oracle.com

syscall test in ltp(not include link )
below is all the failed info. attach is full output
=============================================================
 TDIRECTORY=/ocfs ./runalltests.sh -q -f `pwd`/runtest/syscall-file
access02    1  BROK  :  open(test_file1, O_RDWR|O_CREAT, 0644) Failed, errno=13 :Permission denied
access02    2  BROK  :  Remaining cases broken
access02    3  BROK  :  Remaining cases broken
access02    4  BROK  :  Remaining cases broken
access04    1  BROK  :  mkdir(testdir, 0750) Failed, errno=13 : Permission denied
access05    1  BROK  :  open(test_file1, O_RDWR|O_CREAT, 0644) Failed, errno=13 :Permission denied
access05    2  BROK  :  Remaining cases broken
access05    3  BROK  :  Remaining cases broken
access05    4  BROK  :  Remaining cases broken
access05    5  BROK  :  Remaining cases broken
access05    6  BROK  :  Remaining cases broken
access05    7  BROK  :  Remaining cases broken
access05    8  BROK  :  Remaining cases broken
chdir03     1  FAIL  :  expected EACCES - got 2
chmod03     1  FAIL  :  chmod(testfile, 01777) Failed, errno=1 : Operation not permitted
chmod04     1  BROK  :  mkdir(2) of testdir_4 failed
DIR_MODE = 043000
MODE_RWX = 0777
PERMS = 043777
dir_mode = 043777
chmod06     1  FAIL  :  chmod() fails, Process is not owner/root, errno:1, expected errno:13
chown04     1  BROK  :  mkdir(2) of testdir_1 failed
chown04     2  BROK  :  Remaining cases broken
chown04     3  BROK  :  Remaining cases broken
chown04     4  BROK  :  Remaining cases broken
chown04     5  BROK  :  Remaining cases broken
chown04     6  BROK  :  Remaining cases broken
chown04     7  BROK  :  Remaining cases broken
creat01     1  FAIL  :  Could not creat file creat01.5265
creat01     2  FAIL  :  Could not creat file creat01.5265
creat06     1  BROK  :  couldn't create a test file
creat06     2  BROK  :  Remaining cases broken
creat06     3  BROK  :  Remaining cases broken
creat06     4  BROK  :  Remaining cases broken
creat06     5  BROK  :  Remaining cases broken
creat06     6  BROK  :  Remaining cases broken
dup05       1  BROK  :  mkfifo(dupfile, 0700) Failed, errno=17 : File exists
fchmod04    1  BROK  :  mkdir(2) of testdir_4 failed
fchmod05    1  BROK  :  mkdir(2) of testdir failed
fchmod06    1  BROK  :  open(tfile_2, O_RDWR|O_CREAT, 0666) failed, errno=13 : Permission denied
fchmod06    2  BROK  :  Remaining cases broken
fchown04    1  BROK  :  open(tfile_2, O_RDWR|O_CREAT, 0666) failed, errno=13 : Permission denied
fchown04    2  BROK  :  Remaining cases broken
fstat02     1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) Failed, errno=13 : Permission denied
fstat04     1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) Failed, errno=13 : Permission denied
ftruncate04    1  CONF  :  The filesystem where /tmp is mounted does not support mandatory locks. Cannot run this test.
lchown02    1  BROK  :  chmod() failed
lchown02    2  BROK  :  Remaining cases broken
lchown02    3  BROK  :  Remaining cases broken
lchown02    4  BROK  :  Remaining cases broken
lchown02    5  BROK  :  Remaining cases broken
lchown02    6  BROK  :  Remaining cases broken
lchown02    7  BROK  :  Remaining cases broken
lseek07     1  FAIL  :  read() failed on tmp_file, error=14
lseek09     1  FAIL  :  read() failed on tmp_file, error=14
lseek10     1  BROK  :  mknod(tmp_file1, 0644, 0) Failed, errno=17 :File exists
lseek10     2  BROK  :  Remaining cases broken
lseek10     3  BROK  :  Remaining cases broken
lstat02     1  BROK  :  mkdir(2) of testdir_1 failed
lstat02     2  BROK  :  Remaining cases broken
lstat02     3  BROK  :  Remaining cases broken
lstat02     4  BROK  :  Remaining cases broken
lstat02     5  BROK  :  Remaining cases broken
lstat02     6  BROK  :  Remaining cases broken
lstat03     1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) Failed, errno=13 : Permission denied
mkdir(tstdir1.5489, 777)
current dir /ocfs
mkdir02     1  FAIL  :  mkdir() FAILED to inherit  the group ID 1 from parent  directory 99
mkdir(tstdir1.5489, 777)
current dir /ocfs
mkdir02     1  FAIL  :  Test to attempt to make a directory inherits group ID FAILED
mknod03     1  FAIL  :  tnode_5554: Incorrect group
mknod04     1  FAIL  :  tnode_5555: Incorrect group
mknod06     4  FAIL  :  mknod() returned 0, expected -1, errno:2
mknod07     1  BROK  :  mkdir(2) of testdir_1 failed
mknod07     2  BROK  :  Remaining cases broken
mknod08     1  BROK  :  mkdir(2) of testdir_1 failed
open08      1  BROK  :  Can't creat open3.5591
open08      2  BROK  :  Remaining cases broken
open08      3  BROK  :  Remaining cases broken
open08      4  BROK  :  Remaining cases broken
open08      5  BROK  :  Remaining cases broken
open08      6  BROK  :  Remaining cases broken
readdir01    1  FAIL  :  found more files than were created
readlink01    1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) failed, errno=13 : Permission denied
readlink03    1  BROK  :  mkdir(2) of testdir_1 failed
readlink03    2  BROK  :  Remaining cases broken
readlink03    3  BROK  :  Remaining cases broken
readlink03    4  BROK  :  Remaining cases broken
readlink03    5  BROK  :  Remaining cases broken
creat_slink: symlink() failed: File exists
readlink04    1  FAIL  :  readlink() return value 8 doesn't match, Expected 10
rmdir05     2  CONF  :  rmdir on "dir/." supported on Linux
rmdir05     3  CONF  :  linked directories test not implemented on Linux
stat01      1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) Failed, errno=13 : Permission denied
stat02      1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) Failed, errno=13 : Permission denied
stat03      1  BROK  :  mkdir(2) of testdir_1 failed
stat03      2  BROK  :  Remaining cases broken
stat03      3  BROK  :  Remaining cases broken
stat03      4  BROK  :  Remaining cases broken
stat03      5  BROK  :  Remaining cases broken
stat03      6  BROK  :  Remaining cases broken
statfs03    1  FAIL  :  unexpected error - 20 : Not a directory - expected 13
symlink03    1  BROK  :  mkdir(2) of testdir_1 failed
symlink04    1  FAIL  :  symlink(testfile, slink_file) Failed, errno=17 : File exists
truncate03    1  BROK  :  open(testfile, O_RDWR|O_CREAT, 644) Failed, errno=13 : Permission denied
truncate03    2  BROK  :  Remaining cases broken
truncate03    3  BROK  :  Remaining cases broken
truncate03    4  BROK  :  Remaining cases broken
truncate03    5  BROK  :  Remaining cases broken
truncate04    1  BROK  :  truncate04 - mkdir() in main() failed

>-----Original Message-----
>From: ocfs2-devel-bounces@oss.oracle.com 
>[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Mark Fasheh
>Sent: 2004��8��11�� 11:08
>To: ocfs2-devel@oss.oracle.com
>Subject: [Ocfs2-devel] posix / performance
>
>Intel folks:
>
>Any chance we could get another run with your posix tests? 
>We'd like to see
>what posix holes we have left.
>
>Similarly, we're looking at performance wrt ext3. We've made some
>improvements that went into beta 4 which we're hoping helped 
>out... If it
>isn't too much trouble, another performance benchmark would be greatly
>appreciated as well :)
>	--Mark
>
>--
>Mark Fasheh
>Software Developer, Oracle Corp
>mark.fasheh@oracle.com
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
-------------- next part --------------
A non-text attachment was scrubbed...
Name: ltp.tgz
Type: application/x-compressed
Size: 9451 bytes
Desc: ltp.tgz
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040812/f584f5a4/ltp-0001.bin
