From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Mon Aug 16 00:30:29 2004
Subject: [Ocfs2-devel] new ltp result
Message-ID: <3ACA40606221794F80A5670F0AF15F84052E377F@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I rerun ltp on svn1358, the result is better.

============================================
chdir03     1  FAIL  :  expected EACCES - got 2
chmod03     1  FAIL  :  chmod(testfile, 01777) Failed, errno=1 :
Operation not permitted
chmod05     1  BROK  :  mkdir(2) of testdir failed
chmod06     1  FAIL  :  chmod() fails, Process is not owner/root,
errno:1, expected errno:13
chown04     1  BROK  :  mkdir(2) of testdir_1 failed
chown04     2  BROK  :  Remaining cases broken
chown04     3  BROK  :  Remaining cases broken
chown04     4  BROK  :  Remaining cases broken
chown04     5  BROK  :  Remaining cases broken
chown04     6  BROK  :  Remaining cases broken
chown04     7  BROK  :  Remaining cases broken
creat06     3  FAIL  :  unexpected error - 20 : Not a directory -
expected 2
dup05       1  BROK  :  mkfifo(dupfile, 0700) Failed, errno=17 : File
exists
call returned -1 and ERRNO = EBADF
call returned -1 and ERRNO = EBADF
call returned -1 and ERRNO = EBADF
call returned -1 and ERRNO = EBADF
fchmod04    1  BROK  :  mkdir(2) of testdir_4 failed
fchmod05    1  BROK  :  mkdir(2) of testdir failed
fstat02     1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) Failed,
errno=13 : Permission denied
fstat04     1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) Failed,
errno=13 : Permission denied
Starting test, possible errnos are; EBADF(9) EINVAL(22)
		ENOENT(2) EACCES(13) EPERM(1)
Starting test1
Test Failed as Expected!

Starting test2
Test failed as Expected!

Starting test3
Test failed as Expected!
ftruncate04    1  CONF  :  The filesystem where /tmp is mounted does not
support mandatory locks. Cannot run this test.
lchown02    1  BROK  :  chmod() failed
lchown02    2  BROK  :  Remaining cases broken
lchown02    3  BROK  :  Remaining cases broken
lchown02    4  BROK  :  Remaining cases broken
lchown02    5  BROK  :  Remaining cases broken
lchown02    6  BROK  :  Remaining cases broken
lchown02    7  BROK  :  Remaining cases broken
lseek07     1  FAIL  :  read() failed on tmp_file, error=14
lseek09     1  FAIL  :  read() failed on tmp_file, error=14
lseek10     1  BROK  :  mknod(tmp_file1, 0644, 0) Failed, errno=17 :File
exists
lseek10     2  BROK  :  Remaining cases broken
lseek10     3  BROK  :  Remaining cases broken
lstat02     1  BROK  :  mkdir(2) of testdir_1 failed
lstat02     2  BROK  :  Remaining cases broken
lstat02     3  BROK  :  Remaining cases broken
lstat02     4  BROK  :  Remaining cases broken
lstat02     5  BROK  :  Remaining cases broken
lstat02     6  BROK  :  Remaining cases broken
lstat03     1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) Failed,
errno=13 : Permission denied
mkdir(tstdir1.3878, 777)
current dir /ocfs
mkdir02     1  FAIL  :  mkdir() FAILED to inherit  the group ID 1 from
parent  directory 99
mkdir(tstdir1.3878, 777)
current dir /ocfs
mkdir02     1  FAIL  :  Test to attempt to make a directory inherits
group ID FAILED
mknod03     1  FAIL  :  tnode_3897: Incorrect group
mknod04     1  BROK  :  mkdir(2) of testdir_4 failed
mknod06     4  FAIL  :  mknod() returned 0, expected -1, errno:2
mknod07     1  BROK  :  mkdir(2) of testdir_1 failed
mknod07     2  BROK  :  Remaining cases broken
mknod08     1  BROK  :  mkdir(2) of testdir_1 failed
open08      1  BROK  :  Can't creat open3.3934
open08      2  BROK  :  Remaining cases broken
open08      3  BROK  :  Remaining cases broken
open08      4  BROK  :  Remaining cases broken
open08      5  BROK  :  Remaining cases broken
open08      6  BROK  :  Remaining cases broken
readdir01    1  FAIL  :  found more files than were created
readlink01    1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) failed,
errno=13 : Permission denied
readlink03    1  BROK  :  mkdir(2) of testdir_1 failed
readlink03    2  BROK  :  Remaining cases broken
readlink03    3  BROK  :  Remaining cases broken
readlink03    4  BROK  :  Remaining cases broken
readlink03    5  BROK  :  Remaining cases broken
creat_slink: symlink() failed: File exists
readlink04    1  FAIL  :  readlink() return value 8 doesn't match,
Expected 10
rmdir05     2  CONF  :  rmdir on "dir/." supported on Linux
rmdir05     3  CONF  :  linked directories test not implemented on Linux
stat01      1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) Failed,
errno=13 : Permission denied
stat02      1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) Failed,
errno=13 : Permission denied
stat03      1  BROK  :  mkdir(2) of testdir_1 failed
stat03      2  BROK  :  Remaining cases broken
stat03      3  BROK  :  Remaining cases broken
stat03      4  BROK  :  Remaining cases broken
stat03      5  BROK  :  Remaining cases broken
stat03      6  BROK  :  Remaining cases broken
statfs03    1  FAIL  :  unexpected error - 20 : Not a directory -
expected 13
symlink03    1  BROK  :  mkdir(2) of testdir_1 failed
symlink04    1  FAIL  :  symlink(testfile, slink_file) Failed, errno=17
: File exists
truncate03    1  BROK  :  open(testfile, O_RDWR|O_CREAT, 644) Failed,
errno=13 : Permission denied
truncate03    2  BROK  :  Remaining cases broken
truncate03    3  BROK  :  Remaining cases broken
truncate03    4  BROK  :  Remaining cases broken
truncate03    5  BROK  :  Remaining cases broken
truncate04    1  BROK  :  truncate04 - mkdir() in main() failed

-------------------
Intel China Software Lab.
iNet: 8-752-1243
8621-52574545-1243(O)
503-712-6740(Temp)

xfling@users.sourceforge.net
Opinions are my own and don't represent those of my employer 
