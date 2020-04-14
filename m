From: Vasily Averin <vvs@virtuozzo.com>
Date: Tue, 14 Apr 2020 09:16:53 +0300
Subject: [Ocfs2-devel] [PATCH v3 0/4] ocfs2: seq_operation should properly
 handle position index
In-Reply-To: <085dc97b-de01-1d95-799d-dc795eec7818@virtuozzo.com>
References: <085dc97b-de01-1d95-799d-dc795eec7818@virtuozzo.com>
Message-ID: <af031d8d-d2d5-5393-cda7-a0001bddd66b@virtuozzo.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

v3: rework of ocfs2-related seq_operation functions to properly handle position index argument

v2: resend with improved patch description

In Aug 2018 NeilBrown noticed
commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
"Some ->next functions do not increment *pos when they return NULL...
Note that such ->next functions are buggy and should be fixed.
A simple demonstration is
   
dd if=/proc/swaps bs=1000 skip=1
  
Choose any block size larger than the size of /proc/swaps.  This will
always show the whole last line of /proc/swaps"

/proc/swaps output was fixed recently [1], however there are lot of other
affected files and 4 of them are related to ocfs2.

Moreover lishan@ experiments showed that ocfs2-related seq_operations
completely ignores position index argument and it leads to incorrect output. [2]

Usually you can observe following related problems:
- read after lseek beyond end of file, described above by NeilBrown
 "dd if=<AFFECTED_FILE> bs=1000 skip=1" will incorrectly generate whole last line

- read after lseek on into middle of last line will output expected rest of
 last line but then repeat whole last line once again.

- If .show() function generates multi-line output following bash script will never finish.

 $ q=;while read -r r;do echo "$((++q)) $r";done < AFFECTED_FILE

[1] Link: https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?id=206283__;!!GqivPVa7Brio!M3Zvpw7fOUG9cadeYNB9Nc7yQqx_CxPjQKa1xVL-HV09pGqXsi_4x0J6l5LuvKgjTUVSrQ$ 
[2] Link: https://oss.oracle.com/pipermail/ocfs2-devel/2020-March/014822.html

Vasily Averin (4):
  ocfs2: debug_lockres_ops should properly handle position index
  ocfs2: ocfs2_dlm_seq_ops should properly handle position index
  ocfs2: nst_seq_ops should properly handle position index
  ocfs2: sc_seq_ops should properly handle position index

 fs/ocfs2/cluster/netdebug.c | 24 +++++++-----
 fs/ocfs2/dlm/dlmdebug.c     | 78 ++++++++++++++++++-------------------
 fs/ocfs2/dlmglue.c          | 10 +++--
 3 files changed, 59 insertions(+), 53 deletions(-)

-- 
2.17.1
