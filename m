From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Tue Aug 17 00:49:22 2004
Subject: [Ocfs2-devel] [Bug] LTP: mkdir fail after setreuid
Message-ID: <3ACA40606221794F80A5670F0AF15F840533AB21@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

For chdir03 investigation result:
The fail is caused by the mkdir fail after setreuid.
Key code in the test case:
       if ((pid =3D fork()) < 0) {
            tst_brkm(TBROK, cleanup, "first fork failed");
        }

        if (pid =3D=3D 0) {         /* first child */
            /* set the child's ID to ltpuser1 */
           if (setreuid(ltpuser1->pw_uid, ltpuser1->pw_uid) !=3D 0) {
                 tst_resm(TINFO, "setreuid failed in child #1");
                exit(1);
            }
            if (mkdir(good_dir, 00700) !=3D 0) {
                tst_resm(TINFO, "mkdir failed in child #1");
                exit(1);
            }
            printf("mkdir %s successful\n", good_dir);
            exit(0);
        }=20

if skip the setreuid, the test can pass.
>-----Original Message-----
>From: ocfs2-devel-bounces@oss.oracle.com=20
>[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Ling, Xiaofeng
>Sent: 2004=C4=EA8=D4=C216=C8=D5 13:30
>To: ocfs2-devel@oss.oracle.com
>Subject: [Ocfs2-devel] new ltp result
>
>I rerun ltp on svn1358, the result is better.
>
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>chdir03     1  FAIL  :  expected EACCES - got 2
>chmod03     1  FAIL  :  chmod(testfile, 01777) Failed, errno=3D1 :
>Operation not permitted
>chmod05     1  BROK  :  mkdir(2) of testdir failed
>chmod06     1  FAIL  :  chmod() fails, Process is not owner/root,
>errno:1, expected errno:13
>chown04     1  BROK  :  mkdir(2) of testdir_1 failed
>chown04     2  BROK  :  Remaining cases broken
>chown04     3  BROK  :  Remaining cases broken
>chown04     4  BROK  :  Remaining cases broken
>chown04     5  BROK  :  Remaining cases broken
>chown04     6  BROK  :  Remaining cases broken
>chown04     7  BROK  :  Remaining cases broken
>creat06     3  FAIL  :  unexpected error - 20 : Not a directory -
>expected 2
>dup05       1  BROK  :  mkfifo(dupfile, 0700) Failed, errno=3D17 : File
>exists
>call returned -1 and ERRNO =3D EBADF
>call returned -1 and ERRNO =3D EBADF
>call returned -1 and ERRNO =3D EBADF
>call returned -1 and ERRNO =3D EBADF
>fchmod04    1  BROK  :  mkdir(2) of testdir_4 failed
>fchmod05    1  BROK  :  mkdir(2) of testdir failed
>fstat02     1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) Failed,
>errno=3D13 : Permission denied
>fstat04     1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) Failed,
>errno=3D13 : Permission denied
>Starting test, possible errnos are; EBADF(9) EINVAL(22)
>		ENOENT(2) EACCES(13) EPERM(1)
>Starting test1
>Test Failed as Expected!
>
>Starting test2
>Test failed as Expected!
>
>Starting test3
>Test failed as Expected!
>ftruncate04    1  CONF  :  The filesystem where /tmp is=20
>mounted does not
>support mandatory locks. Cannot run this test.
>lchown02    1  BROK  :  chmod() failed
>lchown02    2  BROK  :  Remaining cases broken
>lchown02    3  BROK  :  Remaining cases broken
>lchown02    4  BROK  :  Remaining cases broken
>lchown02    5  BROK  :  Remaining cases broken
>lchown02    6  BROK  :  Remaining cases broken
>lchown02    7  BROK  :  Remaining cases broken
>lseek07     1  FAIL  :  read() failed on tmp_file, error=3D14
>lseek09     1  FAIL  :  read() failed on tmp_file, error=3D14
>lseek10     1  BROK  :  mknod(tmp_file1, 0644, 0) Failed,=20
>errno=3D17 :File
>exists
>lseek10     2  BROK  :  Remaining cases broken
>lseek10     3  BROK  :  Remaining cases broken
>lstat02     1  BROK  :  mkdir(2) of testdir_1 failed
>lstat02     2  BROK  :  Remaining cases broken
>lstat02     3  BROK  :  Remaining cases broken
>lstat02     4  BROK  :  Remaining cases broken
>lstat02     5  BROK  :  Remaining cases broken
>lstat02     6  BROK  :  Remaining cases broken
>lstat03     1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) Failed,
>errno=3D13 : Permission denied
>mkdir(tstdir1.3878, 777)
>current dir /ocfs
>mkdir02     1  FAIL  :  mkdir() FAILED to inherit  the group ID 1 from
>parent  directory 99
>mkdir(tstdir1.3878, 777)
>current dir /ocfs
>mkdir02     1  FAIL  :  Test to attempt to make a directory inherits
>group ID FAILED
>mknod03     1  FAIL  :  tnode_3897: Incorrect group
>mknod04     1  BROK  :  mkdir(2) of testdir_4 failed
>mknod06     4  FAIL  :  mknod() returned 0, expected -1, errno:2
>mknod07     1  BROK  :  mkdir(2) of testdir_1 failed
>mknod07     2  BROK  :  Remaining cases broken
>mknod08     1  BROK  :  mkdir(2) of testdir_1 failed
>open08      1  BROK  :  Can't creat open3.3934
>open08      2  BROK  :  Remaining cases broken
>open08      3  BROK  :  Remaining cases broken
>open08      4  BROK  :  Remaining cases broken
>open08      5  BROK  :  Remaining cases broken
>open08      6  BROK  :  Remaining cases broken
>readdir01    1  FAIL  :  found more files than were created
>readlink01    1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) failed,
>errno=3D13 : Permission denied
>readlink03    1  BROK  :  mkdir(2) of testdir_1 failed
>readlink03    2  BROK  :  Remaining cases broken
>readlink03    3  BROK  :  Remaining cases broken
>readlink03    4  BROK  :  Remaining cases broken
>readlink03    5  BROK  :  Remaining cases broken
>creat_slink: symlink() failed: File exists
>readlink04    1  FAIL  :  readlink() return value 8 doesn't match,
>Expected 10
>rmdir05     2  CONF  :  rmdir on "dir/." supported on Linux
>rmdir05     3  CONF  :  linked directories test not=20
>implemented on Linux
>stat01      1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) Failed,
>errno=3D13 : Permission denied
>stat02      1  BROK  :  open(testfile, O_RDWR|O_CREAT, 0644) Failed,
>errno=3D13 : Permission denied
>stat03      1  BROK  :  mkdir(2) of testdir_1 failed
>stat03      2  BROK  :  Remaining cases broken
>stat03      3  BROK  :  Remaining cases broken
>stat03      4  BROK  :  Remaining cases broken
>stat03      5  BROK  :  Remaining cases broken
>stat03      6  BROK  :  Remaining cases broken
>statfs03    1  FAIL  :  unexpected error - 20 : Not a directory -
>expected 13
>symlink03    1  BROK  :  mkdir(2) of testdir_1 failed
>symlink04    1  FAIL  :  symlink(testfile, slink_file) Failed, =
errno=3D17
>: File exists
>truncate03    1  BROK  :  open(testfile, O_RDWR|O_CREAT, 644) Failed,
>errno=3D13 : Permission denied
>truncate03    2  BROK  :  Remaining cases broken
>truncate03    3  BROK  :  Remaining cases broken
>truncate03    4  BROK  :  Remaining cases broken
>truncate03    5  BROK  :  Remaining cases broken
>truncate04    1  BROK  :  truncate04 - mkdir() in main() failed
>
>-------------------
>Intel China Software Lab.
>iNet: 8-752-1243
>8621-52574545-1243(O)
>503-712-6740(Temp)
>
>xfling@users.sourceforge.net
>Opinions are my own and don't represent those of my employer=20
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
