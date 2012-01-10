From: Simon Xu <xu.simon@oracle.com>
Date: Tue, 10 Jan 2012 23:48:39 +0800
Subject: [Ocfs2-devel] ltp hugemmap02 fails on ocfs2
Message-ID: <4F0C5DD7.8030508@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tiger,

ltp-20120104 hugemmap02 testcase fails on ocfs2 filesystem with both UEK 
2.6.39-100.0.18 and RHEL 2.6.18-300.el5:

hugemmap02    1  TCONF  :  huge mmap failed to test the scenario
hugemmap02    1  TCONF  :  huge mmap failed to test the scenario
hugemmap02    0  TWARN  :  tst_rmdir: 
rmobj(/mnt/ocfs2/ltp-mQdlAx5411/hugSJXB0B) failed: 
lstat(/mnt/ocfs2/ltp-mQdlAx5411/hugSJXB0B) failed; errno=2: No such file 
or directory
hugemmap02    1  TCONF  :  huge mmap failed to test the scenario
hugemmap02    0  TWARN  :  tst_rmdir: 
rmobj(/mnt/ocfs2/ltp-mQdlAx5411/hugSJXB0B) failed: 
lstat(/mnt/ocfs2/ltp-mQdlAx5411/hugSJXB0B) failed; errno=2: No such file 
or directory
hugemmap02    1  TCONF  :  huge mmap failed to test the scenario
hugemmap02    0  TWARN  :  tst_rmdir: 
rmobj(/mnt/ocfs2/ltp-mQdlAx5411/hugSJXB0B) failed: 
lstat(/mnt/ocfs2/ltp-mQdlAx5411/hugSJXB0B) failed; errno=2: No such file 
or directory
hugemmap02    1  TCONF  :  huge mmap failed to test the scenario
hugemmap02    0  TWARN  :  tst_rmdir: 
rmobj(/mnt/ocfs2/ltp-mQdlAx5411/hugSJXB0B) failed: 
lstat(/mnt/ocfs2/ltp-mQdlAx5411/hugSJXB0B) failed; errno=2: No such file 
or directory
hugemmap02    1  TCONF  :  huge mmap failed to test the scenario
hugemmap02    0  TWARN  :  tst_rmdir: 
rmobj(/mnt/ocfs2/ltp-mQdlAx5411/hugSJXB0B) failed: 
lstat(/mnt/ocfs2/ltp-mQdlAx5411/hugSJXB0B) failed; errno=2: No such file 
or directory
hugemmap02    1  TCONF  :  huge mmap failed to test the scenario
hugemmap02    0  TWARN  :  tst_rmdir: 
rmobj(/mnt/ocfs2/ltp-mQdlAx5411/hugSJXB0B) failed: 
lstat(/mnt/ocfs2/ltp-mQdlAx5411/hugSJXB0B) failed; errno=2: No such file 
or directory
hugemmap02    1  TCONF  :  huge mmap failed to test the scenario
hugemmap02    0  TWARN  :  tst_rmdir: 
rmobj(/mnt/ocfs2/ltp-mQdlAx5411/hugSJXB0B) failed: 
lstat(/mnt/ocfs2/ltp-mQdlAx5411/hugSJXB0B) failed; errno=2: No such file 
or directory
hugemmap02    1  TCONF  :  huge mmap failed to test the scenario
hugemmap02    0  TWARN  :  tst_rmdir: 
rmobj(/mnt/ocfs2/ltp-mQdlAx5411/hugSJXB0B) failed: 
lstat(/mnt/ocfs2/ltp-mQdlAx5411/hugSJXB0B) failed; errno=2: No such file 
or directory
hugemmap02    1  TCONF  :  huge mmap failed to test the scenario
hugemmap02    0  TWARN  :  tst_rmdir: 
rmobj(/mnt/ocfs2/ltp-mQdlAx5411/hugSJXB0B) failed: 
lstat(/mnt/ocfs2/ltp-mQdlAx5411/hugSJXB0B) failed; errno=2: No such file 
or directory

Could you help to investigate on this?

Thanks
Simon
