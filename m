From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Wed Jul  7 04:01:42 2004
Subject: [Ocfs2-devel] posix
Message-ID: <3ACA40606221794F80A5670F0AF15F8404D1C304@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It is the dmesg of when hang in LTP testing.=20
I also met it serveral times when doing some operation before.


------------[ cut here ]------------
kernel BUG at /home/xling/ocfs/oo/src/dir.c:146!
invalid operand: 0000 [#1]
CPU:    0
EIP:    0060:[<e08fa9a0>]    Not tainted
EFLAGS: 00010286   (2.6.6kdb)
EIP is at ocfs_readdir+0x584/0x66b [ocfs2]
eax: 00000020   ebx: d93caf08   ecx: 00000000   edx: c03dbab8
esi: 00000000   edi: 00000000   ebp: db4dd080   esp: d6b57f10
ds: 007b   es: 007b   ss: 0068
Process readdir01 (pid: 23605, threadinfo=3Dd6b56000 task=3Dce60c130)
Stack: e092d280 000000a6 00000000 00000091 d6b57f5c 00000001 00000008 =
00000c00
       00000000 00001126 d6b56000 d6b56000 debfa000 00000001 00000001 =
de856400
       d93caf08 00000000 00000000 00000000 fffffffe db4dd080 d81f2480 =
db4dd0e8
Call Trace:
 [<c0157c84>] vfs_readdir+0x9c/0xae
 [<c0157f8b>] filldir64+0x0/0x101
 [<c0158107>] sys_getdents64+0x7b/0xc1
 [<c0157f8b>] filldir64+0x0/0x101
 [<c0105e15>] sysenter_past_esp+0x52/0x71

Code: 0f 0b 92 00 51 8f 92 e0 e9 84 fc ff ff 8b 54 24 2c 8b 02 c7

23 lines yanked                                               1,1=20

>-----Original Message-----
>From: Ling, Xiaofeng=20

>Sent: 2004=C4=EA7=D4=C27=C8=D5 16:44
>To: 'Wim Coekaerts'; ocfs2-devel@oss.oracle.com
>Subject: RE: [Ocfs2-devel] posix
>
>>-----Original Message-----
>>any chance to rerun the ltp testsuites to see how we are doing these
>>days with all the changes ?
>>
>Follow is the output of LTP about file system call before =20
>hang at readdir02.
>---------------------------------------------------
>TDIRECTORY=3D/ocfs ./runalltests.sh -q -f `pwd`/runtest/syscall-file
>access01    1  PASS  :  access(accessfile, F_OK) returned 0
>access01    2  PASS  :  access(accessfile, X_OK) returned 0
>access01    3  PASS  :  access(accessfile, W_OK) returned 0
>access01    4  PASS  :  access(accessfile, R_OK) returned 0
>access02    1  BROK  :  open(test_file1, O_RDWR|O_CREAT, 0644)=20
>Failed, errno=3D13 :Permission denied
>access02    2  BROK  :  Remaining cases broken
>access02    3  BROK  :  Remaining cases broken
>access02    4  BROK  :  Remaining cases broken
>access03    1  PASS  :  access((char *)-1,R_OK) failed as=20
>expected with errno 14 (EFAULT) : Bad address
>access03    2  PASS  :  access((char *)-1,W_OK) failed as=20
>expected with errno 14 (EFAULT) : Bad address
>access03    3  PASS  :  access((char*)-1,X_OK) failed as=20
>expected with errno 14 (EFAULT) : Bad address
>access03    4  PASS  :  access((char*)-1,F_OK) failed as=20
>expected with errno 14 (EFAULT) : Bad address
>access03    5  PASS  :  access((char*)sbrk(0)+1,R_OK) failed=20
>as expected with errno 14 (EFAULT) : Bad address
>access03    6  PASS  :  access((char*)sbrk(0)+1,W_OK) failed=20
>as expected with errno 14 (EFAULT) : Bad address
>access03    7  PASS  :  access(high_address,X_OK) failed as=20
>expected with errno 14 (EFAULT) : Bad address
>access03    8  PASS  :  access((char*)sbrk(0)+1,F_OK) failed=20
>as expected with errno 14 (EFAULT) : Bad address
>access04    1  BROK  :  mkdir(testdir, 0750) Failed, errno=3D13=20
>: Permission denied
>access05    1  BROK  :  open(test_file1, O_RDWR|O_CREAT, 0644)=20
>Failed, errno=3D13 :Permission denied
>access05    2  BROK  :  Remaining cases broken
>access05    3  BROK  :  Remaining cases broken
>access05    4  BROK  :  Remaining cases broken
>access05    5  BROK  :  Remaining cases broken
>access05    6  BROK  :  Remaining cases broken
>access05    7  BROK  :  Remaining cases broken
>access05    8  BROK  :  Remaining cases broken
>asyncio02    1  PASS  :  More than BUFSIZE bytes multiple=20
>synchronous writes to a file check out ok
>asyncio02    2  PASS  :  BUFSIZE bytes multiple synchronous=20
>writes to a file checks out ok
>asyncio02    3  PASS  :  Less than BUFSIZE bytes multiple=20
>synchronous writes to a file checks out ok
>asyncio02    4  PASS  :  More than BUFSIZE bytes multiple=20
>synchronous writes to a file check out ok
>asyncio02    5  PASS  :  BUFSIZE bytes multiple synchronous=20
>writes to a file checks out ok
>asyncio02    6  PASS  :  Less than BUFSIZE bytes multiple=20
>synchronous writes to a file checks out ok
>chdir01     1  PASS  :  received expected error - 20 : Not a directory
>chdir01     1  PASS  :  chdir(2) to object file location=20
>through symbolic link file is ok
>chdir01     2  PASS  :  chdir(2) to non-existent object file=20
>location through symbolic link file failed as expected
>chdir01     3  PASS  :  Nested symbolic link access condition=20
>caught.  ELOOP is returned
>chdir02     1  PASS  :  chdir(/) returned 0
>chdir03     1  FAIL  :  expected EACCES - got 2
>chdir04     1  PASS  :  expected failure - errno =3D 36 : File=20
>name too long
>chdir04     2  PASS  :  expected failure - errno =3D 2 : No such=20
>file or directory
>chdir04     3  PASS  :  expected failure - errno =3D 14 : Bad address
>chmod01     1  PASS  :  Functionality of chmod(testfile, 0) successful
>chmod01     2  PASS  :  Functionality of chmod(testfile, 07) successful
>chmod01     3  PASS  :  Functionality of chmod(testfile, 070)=20
>successful
>chmod01     4  PASS  :  Functionality of chmod(testfile, 0700)=20
>successful
>chmod01     5  PASS  :  Functionality of chmod(testfile, 0777)=20
>successful
>chmod01     6  PASS  :  Functionality of chmod(testfile,=20
>02777) successful
>chmod01     7  PASS  :  Functionality of chmod(testfile,=20
>04777) successful
>chmod01     8  PASS  :  Functionality of chmod(testfile,=20
>06777) successful
