From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Wed Jul  7 04:06:09 2004
Subject: [Ocfs2-devel] posix
Message-ID: <3ACA40606221794F80A5670F0AF15F8404D1C2D4@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

>-----Original Message-----
>any chance to rerun the ltp testsuites to see how we are doing these
>days with all the changes ?
>
Follow is the output of LTP about file system call before  hang at
readdir02.
---------------------------------------------------
TDIRECTORY=/ocfs ./runalltests.sh -q -f `pwd`/runtest/syscall-file
access01    1  PASS  :  access(accessfile, F_OK) returned 0
access01    2  PASS  :  access(accessfile, X_OK) returned 0
access01    3  PASS  :  access(accessfile, W_OK) returned 0
access01    4  PASS  :  access(accessfile, R_OK) returned 0
access02    1  BROK  :  open(test_file1, O_RDWR|O_CREAT, 0644) Failed,
errno=13 :Permission denied
access02    2  BROK  :  Remaining cases broken
access02    3  BROK  :  Remaining cases broken
access02    4  BROK  :  Remaining cases broken
access03    1  PASS  :  access((char *)-1,R_OK) failed as expected with
errno 14 (EFAULT) : Bad address
access03    2  PASS  :  access((char *)-1,W_OK) failed as expected with
errno 14 (EFAULT) : Bad address
access03    3  PASS  :  access((char*)-1,X_OK) failed as expected with
errno 14 (EFAULT) : Bad address
access03    4  PASS  :  access((char*)-1,F_OK) failed as expected with
errno 14 (EFAULT) : Bad address
access03    5  PASS  :  access((char*)sbrk(0)+1,R_OK) failed as expected
with errno 14 (EFAULT) : Bad address
access03    6  PASS  :  access((char*)sbrk(0)+1,W_OK) failed as expected
with errno 14 (EFAULT) : Bad address
access03    7  PASS  :  access(high_address,X_OK) failed as expected
with errno 14 (EFAULT) : Bad address
access03    8  PASS  :  access((char*)sbrk(0)+1,F_OK) failed as expected
with errno 14 (EFAULT) : Bad address
access04    1  BROK  :  mkdir(testdir, 0750) Failed, errno=13 :
Permission denied
access05    1  BROK  :  open(test_file1, O_RDWR|O_CREAT, 0644) Failed,
errno=13 :Permission denied
access05    2  BROK  :  Remaining cases broken
access05    3  BROK  :  Remaining cases broken
access05    4  BROK  :  Remaining cases broken
access05    5  BROK  :  Remaining cases broken
access05    6  BROK  :  Remaining cases broken
access05    7  BROK  :  Remaining cases broken
access05    8  BROK  :  Remaining cases broken
asyncio02    1  PASS  :  More than BUFSIZE bytes multiple synchronous
writes to a file check out ok
asyncio02    2  PASS  :  BUFSIZE bytes multiple synchronous writes to a
file checks out ok
asyncio02    3  PASS  :  Less than BUFSIZE bytes multiple synchronous
writes to a file checks out ok
asyncio02    4  PASS  :  More than BUFSIZE bytes multiple synchronous
writes to a file check out ok
asyncio02    5  PASS  :  BUFSIZE bytes multiple synchronous writes to a
file checks out ok
asyncio02    6  PASS  :  Less than BUFSIZE bytes multiple synchronous
writes to a file checks out ok
chdir01     1  PASS  :  received expected error - 20 : Not a directory
chdir01     1  PASS  :  chdir(2) to object file location through
symbolic link file is ok
chdir01     2  PASS  :  chdir(2) to non-existent object file location
through symbolic link file failed as expected
chdir01     3  PASS  :  Nested symbolic link access condition caught.
ELOOP is returned
chdir02     1  PASS  :  chdir(/) returned 0
chdir03     1  FAIL  :  expected EACCES - got 2
chdir04     1  PASS  :  expected failure - errno = 36 : File name too
long
chdir04     2  PASS  :  expected failure - errno = 2 : No such file or
directory
chdir04     3  PASS  :  expected failure - errno = 14 : Bad address
chmod01     1  PASS  :  Functionality of chmod(testfile, 0) successful
chmod01     2  PASS  :  Functionality of chmod(testfile, 07) successful
chmod01     3  PASS  :  Functionality of chmod(testfile, 070) successful
chmod01     4  PASS  :  Functionality of chmod(testfile, 0700)
successful
chmod01     5  PASS  :  Functionality of chmod(testfile, 0777)
successful
chmod01     6  PASS  :  Functionality of chmod(testfile, 02777)
successful
chmod01     7  PASS  :  Functionality of chmod(testfile, 04777)
successful
chmod01     8  PASS  :  Functionality of chmod(testfile, 06777)
successful
chmod01     1  PASS  :  chmod(2) of object file permissions through
symbolic link file is ok
chmod01     2  PASS  :  chmod(2) error when accessing non-existent
object through symbolic link is caught
chmod01     3  PASS  :  Nested symbolic link access condition caught.
ELOOP is returned
chmod02     1  PASS  :  chmod(tfile, 0) returned 0
chmod02     2  PASS  :  chmod(tfile, 07) returned 0
chmod02     3  PASS  :  chmod(tfile, 070) returned 0
chmod02     4  PASS  :  chmod(tfile, 0700) returned 0
chmod02     5  PASS  :  chmod(tfile, 0777) returned 0
chmod02     6  PASS  :  chmod(tfile, 02777) returned 0
chmod02     7  PASS  :  chmod(tfile, 04777) returned 0
chmod02     8  PASS  :  chmod(tfile, 06777) returned 0
chmod03     1  FAIL  :  chmod(testfile, 01777) Failed, errno=1 :
Operation not permitted
chmod04     1  BROK  :  mkdir(2) of testdir_4 failed
DIR_MODE = 043000
MODE_RWX = 0777
PERMS = 043777
dir_mode = 043777
chmod05     1  PASS  :  Functionality of chmod(testdir, 043777)
successful
chmod06     1  FAIL  :  chmod() fails, Process is not owner/root,
errno:1, expected errno:13
chmod06     2  PASS  :  chmod() fails, No Search permissions to process,
errno:13
chmod06     3  PASS  :  chmod() fails, Address beyond address space,
errno:14
chmod06     4  PASS  :  chmod() fails, Negative address, errno:14
chmod06     5  PASS  :  chmod() fails, Pathname too long, errno:36
chmod06     6  PASS  :  chmod() fails, Pathname is empty, errno:2
chmod06     7  PASS  :  chmod() fails, Path contains regular file,
errno:20
chmod07     1  PASS  :  Functionality of chmod(testfile, 01777)
successful
chown01     1  PASS  :  chown(t_23229, 0,0) returned 0
chown02     1  PASS  :  chown() on testfile1 succeeds : Setuid/Setgid
bits cleared
chown02     2  PASS  :  chown() on testfile2 succeeds : Setgid bit not
cleared
chown03     1  PASS  :  call succeeded
chown04     1  BROK  :  mkdir(2) of testdir_1 failed
chown04     2  BROK  :  Remaining cases broken
chown04     3  BROK  :  Remaining cases broken
chown04     4  BROK  :  Remaining cases broken
chown04     5  BROK  :  Remaining cases broken
chown04     6  BROK  :  Remaining cases broken
chown04     7  BROK  :  Remaining cases broken
chown05     1  PASS  :  chown() succeeds to Change Owner/Group ids of
testfile
chown05     2  PASS  :  chown() succeeds to Change Owner id only of
testfile
chown05     3  PASS  :  chown() succeeds to Change Owner id only of
testfile
chown05     4  PASS  :  chown() succeeds to Change Group id only of
testfile
chown05     5  PASS  :  chown() succeeds to Change Group id only of
testfile
chroot01    1  PASS  :  chroot set errno to EPERM.
chroot02    1  PASS  :  We appear to be in the right place
chroot03    1  PASS  :  expected failure - errno = 36 : File name too
long
chroot03    2  PASS  :  expected failure - errno = 20 : Not a directory
chroot03    3  PASS  :  expected failure - errno = 2 : No such file or
directory
chroot03    4  PASS  :  expected failure - errno = 14 : Bad address
chroot04    1  PASS  :  expected failure - errno = 13 : Permission
denied
close01     1  PASS  :  file appears closed
close01     2  PASS  :  pipe appears closed
close02     1  PASS  :  call returned EBADF
close08     1  PASS  :  close(tfile_23246) returned 0
creat01     1  FAIL  :  Could not creat file creat01.23247
creat01     2  FAIL  :  Could not creat file creat01.23247
creat03     1  PASS  :  save text bit cleared
creat04     1  PASS  :  call failed with expected EACCES error
creat04     2  PASS  :  call failed with expected EACCES error
creat05     1  PASS  :  call failed with expected error - EMFILE
creat06     1  BROK  :  couldn't create a test file
creat06     2  BROK  :  Remaining cases broken
creat06     3  BROK  :  Remaining cases broken
creat06     4  BROK  :  Remaining cases broken
creat06     5  BROK  :  Remaining cases broken
creat06     6  BROK  :  Remaining cases broken
creat07     1  PASS  :  received ETXTBSY
creat08     1  PASS  :  Test passed in block0.
creat08     2  PASS  :  Test passed in block1.
creat08     3  PASS  :  Test passed in block2.
creat08     4  PASS  :  Test passed in block3.
creat08     5  PASS  :  Test passed.
creat09     1  PASS  :  creat(tfile_23260, 0700) returned 3
dup01       1  PASS  :  dup(dupfile) returned 4
dup02       1  PASS  :  dup(-1) Failed, errno=9 : Bad file descriptor
dup02       2  PASS  :  dup(1500) Failed, errno=9 : Bad file descriptor
dup03       1  PASS  :  dup(3) Failed, errno=24 : Too many open files
dup04       1  PASS  :  dup(3) read side of syspipe returned 5
dup04       2  PASS  :  dup(4) write side of syspipe returned 5
dup05       1  BROK  :  mkfifo(dupfile, 0700) Failed, errno=17 : File
exists
dup06       1  PASS  :  Test passed.

dup07       1  PASS  :  Test passed in read mode.

dup07       2  PASS  :  Test passed in write mode.

dup07       3  PASS  :  Test passed in read/write mode.

dup07       4  PASS  :  Test passed

call returned -1 and ERRNO = EBADF
call returned -1 and ERRNO = EBADF
call returned -1 and ERRNO = EBADF
call returned -1 and ERRNO = EBADF
dup202      1  PASS  :  fstat() shows new and old modes are the same
dup202      2  PASS  :  fstat() shows new and old modes are the same
dup202      3  PASS  :  fstat() shows new and old modes are the same
dup203      1  PASS  :  dup2 test 1 functionality is correct
dup203      2  PASS  :  dup2 test 2 functionality is correct
dup204      1  PASS  :  original and duped inodes are the same
dup204      2  PASS  :  original and duped inodes are the same
dup205      1  PASS  :  Test passed.

fchdir01    1  PASS  :  fchdir01 call succeeded
fchdir02    1  PASS  :  expected failure - errno = 9 : Bad file
descriptor
fchmod01    1  PASS  :  fchmod(tfile_23278, 0700) returned 0
fchmod02    1  PASS  :  Functionality of fchmod(3, 01777) Successful
fchmod03    1  PASS  :  Functionality of fchmod(3, 01777) successful
fchmod04    1  BROK  :  mkdir(2) of testdir_4 failed
fchmod05    1  BROK  :  mkdir(2) of testdir failed
fchmod06    1  BROK  :  open(tfile_2, O_RDWR|O_CREAT, 0666) failed,
errno=13 : Permission denied
fchmod06    2  BROK  :  Remaining cases broken
fchmod07    1  PASS  :  Functionality of fchmod(3, 0) successful
fchmod07    2  PASS  :  Functionality of fchmod(3, 07) successful
fchmod07    3  PASS  :  Functionality of fchmod(3, 070) successful
fchmod07    4  PASS  :  Functionality of fchmod(3, 0700) successful
fchmod07    5  PASS  :  Functionality of fchmod(3, 0777) successful
fchmod07    6  PASS  :  Functionality of fchmod(3, 02777) successful
fchmod07    7  PASS  :  Functionality of fchmod(3, 04777) successful
fchmod07    8  PASS  :  Functionality of fchmod(3, 06777) successful
fchown01    1  PASS  :  fchown(Fd, geteuid(), getegid()) returned 0
fchown02    1  PASS  :  fchown() on testfile1 succeeds : Setuid/Setgid
bits cleared
fchown02    2  PASS  :  fchown() on testfile2 succeeds : Setgid bit not
cleared
fchown03    1  PASS  :  fchown() on testfile succeeds: Setuid/gid bits
cleared
fchown04    1  BROK  :  open(tfile_2, O_RDWR|O_CREAT, 0666) failed,
errno=13 : Permission denied
fchown04    2  BROK  :  Remaining cases broken
fchown05    1  PASS  :  fchown() succeeds to Change Owner/Group ids of
testfile
fchown05    2  PASS  :  fchown() succeeds to Change Owner id only of
testfile
fchown05    3  PASS  :  fchown() succeeds to Change Owner id only of
testfile
fchown05    4  PASS  :  fchown() succeeds to Change Group id only of
testfile
fchown05    5  PASS  :  fchown() succeeds to Change Group id only of
testfile
fcntl02     1  PASS  :  fcntl(tfile_23301, F_DUPFD, 0) returned 4
fcntl03     1  PASS  :  fcntl(tfile_23302, F_GETFD, 0) returned 0
fcntl04     1  PASS  :  fcntl(tfile_23303, F_GETFL, 0) returned 2
fcntl05     1  PASS  :  fcntl(tfile_23304, F_GETLK, &flocks) returned 0
fcntl06     1  PASS  :  Block 1 PASSED
fcntl07     1  PASS  :  regular file child exited 0, indicating that the
file was closed
fcntl07     2  PASS  :  write side of system pipe child exited 0,
indicating that the file was closed
fcntl07B    1  PASS  :  named pipe child exited 0, indicating that the
file was closed
fcntl08     1  PASS  :  fcntl(tfile_23311, F_SETFL, 3072) returned 0
fcntl09     1  PASS  :  fcntl(./file_23312, F_SETLK, &flocks)
flocks.l_type = F_WRLCK returned 0
fcntl09     2  PASS  :  fcntl(./file_23312, F_SETLK, &flocks)
flocks.l_type = F_UNLCK returned 0
fcntl09     1  PASS  :  fcntl(./file_23312, F_SETLK, &flocks)
flocks.l_type = F_RDLCK returned 0
fcntl09     2  PASS  :  fcntl(./file_23312, F_SETLK, &flocks)
flocks.l_type = F_UNLCK returned 0
fcntl10     1  PASS  :  fcntl(tfile_23313, F_SETLKW, &flocks)
flocks.l_type = F_WRLCK returned 0
fcntl10     2  PASS  :  fcntl(tfile_23313, F_SETLKW, &flocks)
flocks.l_type = F_UNLCK returned 0
fcntl10     1  PASS  :  fcntl(tfile_23313, F_SETLKW, &flocks)
flocks.l_type = F_RDLCK returned 0
fcntl10     2  PASS  :  fcntl(tfile_23313, F_SETLKW, &flocks)
flocks.l_type = F_UNLCK returned 0
fcntl14     1  PASS  :  testcase:2 PASSED
fcntl14     2  PASS  :  testcase:4 PASSED
fcntl14     3  PASS  :  testcase:6 PASSED
fcntl14     4  PASS  :  testcase:8 PASSED
fcntl14     5  PASS  :  testcase:10 PASSED
fcntl14     6  PASS  :  testcase:12 PASSED
fcntl14     7  PASS  :  testcase:14 PASSED
fcntl14     8  PASS  :  testcase:16 PASSED
fcntl14     9  PASS  :  testcase:18 PASSED
fcntl14    10  PASS  :  testcase:20 PASSED
fcntl14    11  PASS  :  testcase:22 PASSED
fcntl14    12  PASS  :  testcase:24 PASSED
fcntl14    13  PASS  :  testcase:26 PASSED
fcntl14    14  PASS  :  testcase:28 PASSED
fcntl14    15  PASS  :  testcase:30 PASSED
fcntl14    16  PASS  :  testcase:32 PASSED
fcntl14    17  PASS  :  testcase:34 PASSED
fcntl14    18  PASS  :  testcase:36 PASSED
fcntl14    19  PASS  :  Block 1, test 1 PASSED
fcntl14    20  PASS  :  testcase:37 PASSED
fcntl14    21  PASS  :  testcase:38 PASSED
fcntl14    22  PASS  :  testcase:39 PASSED
fcntl14    23  PASS  :  testcase:40 PASSED
fcntl14    24  PASS  :  testcase:41 PASSED
fcntl14    25  PASS  :  testcase:42 PASSED
fcntl14    26  PASS  :  testcase:43 PASSED
fcntl14    27  PASS  :  testcase:44 PASSED
fcntl14    28  PASS  :  testcase:45 PASSED
fcntl14    29  PASS  :  Block 1, test 2 PASSED
fcntl14    30  PASS  :  testcase:2 PASSED
fcntl14    31  PASS  :  testcase:4 PASSED
fcntl14    32  PASS  :  testcase:6 PASSED
fcntl14    33  PASS  :  testcase:8 PASSED
fcntl14    34  PASS  :  testcase:10 PASSED
fcntl14    35  PASS  :  testcase:12 PASSED
fcntl14    36  PASS  :  testcase:14 PASSED
fcntl14    37  PASS  :  testcase:16 PASSED
fcntl14    38  PASS  :  testcase:18 PASSED
fcntl14    39  PASS  :  testcase:20 PASSED
fcntl14    40  PASS  :  testcase:22 PASSED
fcntl14    41  PASS  :  testcase:24 PASSED
fcntl14    42  PASS  :  testcase:26 PASSED
fcntl14    43  PASS  :  testcase:28 PASSED
fcntl14    44  PASS  :  testcase:30 PASSED
fcntl14    45  PASS  :  testcase:32 PASSED
fcntl14    46  PASS  :  testcase:34 PASSED
fcntl14    47  PASS  :  testcase:36 PASSED
fcntl14    48  PASS  :  Block 2, test 1 PASSED
fcntl14    49  PASS  :  testcase:37 PASSED
fcntl14    50  PASS  :  testcase:38 PASSED
fcntl14    51  PASS  :  testcase:39 PASSED
fcntl14    52  PASS  :  testcase:40 PASSED
fcntl14    53  PASS  :  testcase:41 PASSED
fcntl14    54  PASS  :  testcase:42 PASSED
fcntl14    55  PASS  :  testcase:43 PASSED
fcntl14    56  PASS  :  testcase:44 PASSED
fcntl14    57  PASS  :  testcase:45 PASSED
fcntl14    58  PASS  :  Block 2, test 2 PASSED
fcntl14    57  PASS  :  testcase:45 PASSED
fcntl14    58  PASS  :  Block 2, test 2 PASSED
fcntl18     1  PASS  :  Test F_GETLK: for errno EFAULT PASSED
fcntl18     2  PASS  :  Test F_GETLK64: for errno EFAULT PASSED
fcntl18     3  PASS  :  Test for errno EINVAL PASSED
fcntl18     1  PASS  :  Test F_GETLK: for errno EFAULT PASSED
fcntl18     2  PASS  :  Test F_GETLK64: for errno EFAULT PASSED
fcntl22     1  PASS  :  fcntl() fails with expected error EAGAIN
errno:11
fcntl23     1  PASS  :  fcntl(tfile_23399, F_SETLEASE,F_RDLCK)
fdatasync01    1  PASS  :  fdatasync() successful
fdatasync02    1  PASS  :  Expected failure for invalid file descriptor,
errno: 9
fdatasync02    2  PASS  :  Expected failure for file descriptor to a
special file, errno: 22
flock01     1  PASS  :  flock() succeded with Shared Lock, returned
error number=0
flock01     2  PASS  :  flock() succeded with Unlock, returned error
number=0
flock01     3  PASS  :  flock() succeded with Exclusive Lock, returned
error number=0
flock02     1  PASS  :  flock() shows expected failure,error number=9 :
Bad file descriptor
flock02     2  PASS  :  flock() shows expected failure,error number=22 :
Invalid argument
flock02     3  PASS  :  flock() shows expected failure with invalid
combination of arguments, error number=22 : Invalid argument
flock03     1  PASS  :  Child: Unlocked file locked by parent
flock03     2  PASS  :  Child: flock after unlocking passed
flock03     1  PASS  :  Parent: Initial attempt to flock() passed
flock03     2  PASS  :  flock03 Passed
flock04     1  PASS  :  flock() PASSED in acquiring shared lock on Share
Locked file
flock04     1  PASS  :  flock() failed to acquire exclusive lock on
existing share locked file as expected
flock05     1  PASS  :  flock() failed to acquire shared lock on an
alreadyexclusive locked file as expected
flock05     1  PASS  :  flock() failed to acquire exclusive lock on
existing  exclusive locked file as expected
flock06     1  PASS  :  First attempt to flock() passed
flock06     2  PASS  :  Second attempt to flock() denied
flock06     3  PASS  :  Unlocked fd1
flock06     4  PASS  :  Third attempt to flock() succeeded
fstat01     1  PASS  :  fstat(tfile_23413, &statter) returned 0
fstat02     1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) Failed,
errno=13 : Permission denied
fstat03     1  PASS  :  fstat() fails with expected error EBADF
fstat04     1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) Failed,
errno=13 : Permission denied
fstatfs01    1  PASS  :  fstatfs(3, &stats, sizeof(struct statfs), 0)
returned 0
fstatfs02    1  PASS  :  expected failure - errno = 9 : Bad file
descriptor
fstatfs02    2  PASS  :  expected failure - errno = 14 : Bad address
fsync01     1  PASS  :  fsync(tfile_23420) returned 0
fsync02     1  BROK  :  Unexpected signal 8 received.
fsync03     1  PASS  :  expected failure - errno = 9 : Bad file
descriptor
fsync03     2  PASS  :  expected failure - errno = 22 : Invalid argument
ftruncate01    1  PASS  :  Functionality of ftruncate() on testfile
successful
ftruncate02    1  PASS  :  Functionality of ftruncate(2) on testfile
successful
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
getcwd01    1  PASS  :  Test case 1 PASSED
getcwd01    2  PASS  :  Test case 2 PASSED
getcwd01    3  PASS  :  Test case 3 PASSED
getcwd01    4  PASS  :  Test case 4 PASSED
getcwd02    1  PASS  :  Block 1 PASSED
getcwd02    2  PASS  :  Block 2 PASSED
getcwd02    3  PASS  :  Block 3 PASSED
getcwd02    4  PASS  :  Block 4 PASSED
getcwd02    5  PASS  :  Block 5 PASSED
getcwd02    6  PASS  :  Block 6 PASSED
getcwd02    7  PASS  :  Block 7 PASSED
getcwd03    1  PASS  :  Test PASSED
getdents01    1  PASS  :  getdents01 call succeeded
getdents02    1  PASS  :  expected failure - errno = 9 - Bad file
descriptor
getdents03    1  PASS  :  expected failure - errno = 22 - Invalid
argument
getdents04    1  PASS  :  expected failure - errno = 20 - Not a
directory
lchown01    1  PASS  :  lchown() succeeds to Change Owner/Group ids of
slink_file
lchown01    2  PASS  :  lchown() succeeds to Change Owner id only of
slink_file
lchown01    3  PASS  :  lchown() succeeds to Change Owner id only of
slink_file
lchown01    4  PASS  :  lchown() succeeds to Change Group id only of
slink_file
lchown01    5  PASS  :  lchown() succeeds to Change Group id only of
slink_file
change_owner: symlink() of /ocfs/tfile_1 Failed, errno=13 : Permission
deniedlchown02    1  BROK  :  Fail to modify tfile_1 ownership(s)!
lchown02    2  BROK  :  Remaining cases broken
lchown02    3  BROK  :  Remaining cases broken
lchown02    4  BROK  :  Remaining cases broken
lchown02    5  BROK  :  Remaining cases broken
lchown02    6  BROK  :  Remaining cases broken
lchown02    7  BROK  :  Remaining cases broken
listen01    1  PASS  :  bad file descriptor successful
listen01    2  PASS  :  not a socket successful
listen01    3  PASS  :  UDP listen successful
llseek02    1  PASS  :  llseek() fails, 'whence' argument is not valid,
errno:22
llseek02    2  PASS  :  llseek() fails, 'fd' is not an open file
descriptor, errno:9
lseek01     1  PASS  :  lseek(tfile_23453, 0, 0) returned 0
lseek01     2  PASS  :  lseek(tfile_23453, 0, 1) returned 0
lseek01     3  PASS  :  lseek(tfile_23453, 0, 2) returned 0
lseek02     1  PASS  :  lseek(-1, 1, SEEK_SET) Failed, errno=9 : Bad
file descriptor
lseek03     1  PASS  :  lseek(tfile_23455, 1, 4) Failed, errno=22 :
Invalid argument
lseek03     2  PASS  :  lseek(tfile_23455, 1, -1) Failed, errno=22 :
Invalid argument
lseek03     3  PASS  :  lseek(tfile_23455, 1, 7) Failed, errno=22 :
Invalid argument
lseek04     1  PASS  :  lseek(fifofd, 1, SEEK_SET) Failed, errno=29 :
Illegal seek
lseek05     1  PASS  :  lseek(pipefd, 1, SEEK_SET) Failed, errno=29 :
Illegal seek
lseek06     1  PASS  :  Functionality of lseek() on tmp_file successful
lseek07     1  FAIL  :  read() failed on tmp_file, error=14
lseek08     1  PASS  :  Functionality of lseek() on tmp_file successful
lseek09     1  FAIL  :  read() failed on tmp_file, error=14
lseek10     1  BROK  :  mknod(tmp_file1, 0644, 0) Failed, errno=17 :File
exists
lseek10     2  BROK  :  Remaining cases broken
lseek10     3  BROK  :  Remaining cases broken
lstat01     1  PASS  :  lstat(2) of symbolic link file which points to
no object file is ok
lstat01     2  PASS  :  lstat(2) of symbolic link file which points at
an object file is ok
lstat01     3  PASS  :  lstat(2) of object file returns object file
inode information
lstat01     1  PASS  :  lstat(lnfile_23464, &statter) returned 0
lstat02     1  BROK  :  mkdir(2) of testdir_1 failed
lstat02     2  BROK  :  Remaining cases broken
lstat02     3  BROK  :  Remaining cases broken
lstat02     4  BROK  :  Remaining cases broken
lstat02     5  BROK  :  Remaining cases broken
lstat02     6  BROK  :  Remaining cases broken
lstat03     1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) Failed,
errno=13 : Permission denied
mkdir01     1  PASS  :  mkdir - path argument pointing below allocated
address space failed as expected with errno 14 : Bad address
mkdir01     2  PASS  :  mkdir - path argument pointing above allocated
address space failed as expected with errno 14 : Bad address
mkdir: Permission denied
mkdir02     1  FAIL  :  mkdir() failed to create a directory with Set
group ID turn on 
mkdir02     1  FAIL  :  Test to attempt to make a directory inherits
group ID FAILED 
mkdir03     1  PASS  :  expected failure - errno = 14 : Bad address
mkdir03     2  PASS  :  expected failure - errno = 36 : File name too
long
mkdir03     3  PASS  :  expected failure - errno = 17 : File exists
mkdir03     4  PASS  :  expected failure - errno = 2 : No such file or
directory
mkdir03     5  PASS  :  expected failure - errno = 20 : Not a directory
mkdir04     1  FAIL  :  mkdir(tstdir1.23471, 0700) Failed
mkdir04     1  FAIL  :  Test to check mkdir EACCES failedin create
parent directory
mkdir05     1  FAIL  :  mkdir(tstdir1.23473, 0777) Failed
mkdir05     1  PASS  :  mkdir(2) of object file through symbolic link
file failed as expected
mkdir08     1  PASS  :  mkdir(./dir_23475) returned 0
mkdir09     1  PASS  :  PASS
mknod01     1  PASS  :  mknod(./tnode_23483, 0100777, 0) returned 0
mknod01     2  PASS  :  mknod(./tnode_23483, 010777, 0) returned 0
mknod01     3  PASS  :  mknod(./tnode_23483, 020777, 0) returned 0
mknod01     4  PASS  :  mknod(./tnode_23483, 060777, 0) returned 0
mknod01     5  PASS  :  mknod(./tnode_23483, 0104700, 0) returned 0
mknod01     6  PASS  :  mknod(./tnode_23483, 0102700, 0) returned 0
mknod01     7  PASS  :  mknod(./tnode_23483, 0106700, 0) returned 0
mknod02     1  PASS  :  Functionality of mknod(tnode_23484, 012777, 0)
successful
mknod03     1  FAIL  :  tnode_23485: Incorrect group
mknod04     1  FAIL  :  tnode_23486: Incorrect group
mknod05     1  PASS  :  Functionality of mknod(tnode_23487, 012777, 0)
successful
mknod06     1  PASS  :  mknod() fails, Specified node already exists,
errno:17
mknod06     2  PASS  :  mknod() fails, Address beyond address space,
errno:14
mknod06     3  PASS  :  mknod() fails, Negative address, errno:14
mknod06     4  FAIL  :  mknod() returned 0, expected -1, errno:2
mknod06     5  PASS  :  mknod() fails, Pathname is empty, errno:2
mknod06     6  PASS  :  mknod() fails, Pathname too long, errno:36
mknod06     7  PASS  :  mknod() fails, Path contains regular file,
errno:20
mknod07     1  BROK  :  mkdir(2) of testdir_1 failed
mknod07     2  BROK  :  Remaining cases broken
mknod08     1  BROK  :  mkdir(2) of testdir_1 failed
mknod09     1  PASS  :  mknod() fails with expected error EINVAL
errno:22
mlock01     1  PASS  :  test 0 passed length = 1
mlock01     2  PASS  :  test 1 passed length = 1024
mlock01     3  PASS  :  test 2 passed length = 1048576
mlock01     4  PASS  :  test 3 passed length = 10485760
mlock02     1  PASS  :  expected failure - errno = 12 : Cannot allocate
memory
mmap001     1  PASS  :  mmap() completed successfully.
mmap001     2  PASS  :  we're still here, mmaped area must be good
mmap001     3  PASS  :  msync() was successful
mmap001     4  PASS  :  munmap() was successful
mmap01      1  FAIL  :  mapped memory area contains invalid data
mmap02      1  PASS  :  Functionality of mmap() successful
mmap03      1  PASS  :  Functionality of mmap() successful
mmap04      1  PASS  :  Functionality of mmap() successful
mmap05      1  PASS  :  Got SIGSEGV as expected
mmap06      1  PASS  :  mmap() fails, 'fd' doesn't allow desired access,
errno:13
mmap07      1  PASS  :  mmap() fails, 'fd' doesn't allow desired access,
errno:13
mmap08      1  PASS  :  mmap() fails, 'fd' is not valid, errno:9
mmap09      1  PASS  :  ftruncate mmaped file to a smaller size
mmap09      2  PASS  :  ftruncate mmaped file to a larger size
mmap09      3  PASS  :  ftruncate mmaped file to 0 size
mremap01    1  PASS  :  Functionality of mremap() is correct
mremap02    1  PASS  :  mremap() Failed, 'invalid argument specified' -
errno 22
mremap03    1  PASS  :  mremap() Fails, 'old region not mapped', errno
14
mremap04    1  PASS  :  mremap() failed, 'MREMAP_MAYMOVE flag unset',
errno 12
munmap01    1  PASS  :  Functionality of munmap() successful
munmap02    1  PASS  :  Functionality of munmap() successful
munmap03    1  PASS  :  munmap() fails, mapped address is invalid,
errno:22
open01      1  PASS  :  Save text bit not cleared as expected
open01      2  PASS  :  directory bit is set as expected
open01      1  PASS  :  open(2) with (O_CREAT | O_RDWR) to create object
file through symbolic link file and all writes, reads, and lseeks are ok
open01      2  PASS  :  open(2) with O_RDWR of existing  object file
through symbolic link file and all writes, reads, and lseeks are ok
open01      3  PASS  :  open(2) with (O_CREAT | O_EXCL) error  is caught
when creating object file through symbolic link file
open01      4  PASS  :  open(2) error with O_RDWR is caught when
processing symbolic link file which points at no object file
open01      5  PASS  :  Nested symbolic link access condition caught.
ELOOP is returned
open02      1  PASS  :  open returned ENOENT
open03      1  PASS  :  open(tfile_23514, O_RDWR|O_CREAT,0700) returned
3
open04      1  PASS  :  call returned expected EMFILE error
open05      1  PASS  :  open returned expected EACCES error
open06      1  PASS  :  call returned expected ENXIO error
open07      1  PASS  :  open returned expected ELOOP error
open07      2  PASS  :  open returned expected ELOOP error
open07      3  PASS  :  open returned expected ELOOP error
open07      4  PASS  :  open returned expected ELOOP error
open08      1  BROK  :  Can't creat open3.23520
open08      2  BROK  :  Remaining cases broken
open08      3  BROK  :  Remaining cases broken
open08      4  BROK  :  Remaining cases broken
open08      5  BROK  :  Remaining cases broken
open08      6  BROK  :  Remaining cases broken
open09      1  PASS  :  Test passed in block0.
open09      2  PASS  :  Test passed in block1.
open09      3  PASS  :  Test passed.
open10      1  PASS  :  Test passed in block0.
open10      2  PASS  :  Test passed in block1.
open10      3  PASS  :  Test passed in block2.
open10      4  PASS  :  Test passed in block3.
open10      5  PASS  :  Test passed.
pipe01      1  PASS  :  pipe() functionality is correct
pipe02      1  PASS  :  child process returned expected SIGPIPE
pipe03      1  PASS  :  expected failure writing to read end of pipe
pipe03      2  PASS  :  expected failure reading from write end of pipe
pipe04      1  PASS  :  Child 1 killed while writing to a pipe
pipe04      2  PASS  :  Child 2 killed while writing to a pipe
pipe05      1  PASS  :  expected failure - errno = 14 : Bad address
pipe06      1  PASS  :  expected failure - errno = 24 : Too many open
files
pipe07      1  PASS  :  Opened 510 pipes
pipe08      1  PASS  :  got expected SIGPIPE signal
pipe09      1  PASS  :  functionality appears to be correct
pipe10      1  PASS  :  functionality is correct
pipe11      1  PASS  :  child 1 exitted successfully
pipe11      2  PASS  :  child 2 exitted successfully
pipe11      3  PASS  :  child 3 exitted successfully
pipe11      4  PASS  :  child 4 exitted successfully
pipe11      5  PASS  :  child 5 exitted successfully
pipe11      6  PASS  :  child 6 exitted successfully
pipe11      7  PASS  :  child 7 exitted successfully
pipe11      8  PASS  :  child 8 exitted successfully
pipe11      9  PASS  :  child 9 exitted successfully
pipe11     10  PASS  :  child 10 exitted successfully
pipe11     11  PASS  :  child 11 exitted successfully
pipe11     12  PASS  :  child 12 exitted successfully
pipe11     13  PASS  :  child 13 exitted successfully
pipe11     14  PASS  :  child 14 exitted successfully
pipe11     15  PASS  :  child 15 exitted successfully
pipe11     16  PASS  :  child 16 exitted successfully
pipe11     17  PASS  :  child 17 exitted successfully
pipe11     18  PASS  :  child 18 exitted successfully
pipe11     19  PASS  :  child 19 exitted successfully
pipe11     20  PASS  :  child 20 exitted successfully
pipe11     21  PASS  :  child 21 exitted successfully
pipe11     22  PASS  :  child 22 exitted successfully
pipe11     23  PASS  :  child 23 exitted successfully
pipe11     24  PASS  :  child 24 exitted successfully
pipe11     25  PASS  :  child 25 exitted successfully
pipe11     26  PASS  :  child 26 exitted successfully
pipe11     27  PASS  :  child 27 exitted successfully
pipe11     28  PASS  :  child 28 exitted successfully
pipe11     29  PASS  :  child 29 exitted successfully
pipe11     30  PASS  :  child 30 exitted successfully
pipe11     31  PASS  :  child 31 exitted successfully
pipe11     32  PASS  :  child 32 exitted successfully
pipe11     33  PASS  :  child 33 exitted successfully
pipe11     34  PASS  :  child 34 exitted successfully
pipe11     35  PASS  :  child 35 exitted successfully
pipe11     36  PASS  :  child 36 exitted successfully
pipe11     37  PASS  :  child 37 exitted successfully
pipe11     38  PASS  :  child 38 exitted successfully
pipe11     39  PASS  :  child 39 exitted successfully
pipe11     40  PASS  :  child 40 exitted successfully
pipe11     41  PASS  :  child 41 exitted successfully
pipe11     42  PASS  :  child 42 exitted successfully
pipe11     43  PASS  :  child 43 exitted successfully
pipe11     44  PASS  :  child 44 exitted successfully
pipe11     45  PASS  :  child 45 exitted successfully
pipe11     46  PASS  :  child 46 exitted successfully
pipe11     47  PASS  :  child 47 exitted successfully
pipe11     48  PASS  :  child 48 exitted successfully
pipe11     49  PASS  :  child 49 exitted successfully
pipe11     50  PASS  :  child 50 exitted successfully
pread01     1  PASS  :  Functionality of pread() is correct
pread02     1  PASS  :  pread() fails, file descriptor is a PIPE or
FIFO, errno:29
pread02     2  PASS  :  pread() fails, specified offset is -ve or
invalid, errno:22
pread03     1  PASS  :  pread() fails with expected error EISDIR
errno:21
pwrite01    1  PASS  :  Functionality of pwrite() successful
pwrite02    1  PASS  :  file descriptor is a PIPE or FIFO, errno:29
pwrite02    2  PASS  :  specified offset is -ve or invalid, errno:22
pwrite02    3  PASS  :  file descriptor is bad, errno:9
pwrite03    1  PASS  :  pwrite() fails with expected error EFAULT
errno:14
pwrite04    1  PASS  :  O_APPEND test passed.

read01      1  PASS  :  read(pfds) returned 512
read02      1  PASS  :  expected failure - errno = 9 : Bad file
descriptor
read02      2  PASS  :  expected failure - errno = 21 : Is a directory
read02      3  PASS  :  expected failure - errno = 14 : Bad address
read04      1  PASS  :  functionality of read() is correct
 
