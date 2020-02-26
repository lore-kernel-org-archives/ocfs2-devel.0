From: Vasily Averin <vvs@virtuozzo.com>
Date: Wed, 26 Feb 2020 09:52:41 +0300
Subject: [Ocfs2-devel] [PATCH v2 0/4] ocfs2: seq_file .next functions should
 increase position index
In-Reply-To: <109025ac-74e9-6afe-3790-c7adbdaa3053@linux.alibaba.com>
References: <109025ac-74e9-6afe-3790-c7adbdaa3053@linux.alibaba.com>
Message-ID: <f9827f6e-e30d-4582-e16b-498335a2144c@virtuozzo.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

v2: resend with improved patch description

In Aug 2018 NeilBrown noticed 
commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
"Some ->next functions do not increment *pos when they return NULL...
Note that such ->next functions are buggy and should be fixed. 
A simple demonstration is
   
dd if=/proc/swaps bs=1000 skip=1
    
Choose any block size larger than the size of /proc/swaps.  This will
always show the whole last line of /proc/swaps"

/proc/swaps output was fixed recently, however there are lot of other
affected files and 4 of them are related to ocfs2.

Unfortunately I'm not familiar with ocfs2 and cannot verify the patches locally.

Usually you can observe following related problems:
- read after lseek beyond end of file, described above by NeilBrown
 "dd if=<AFFECTED_FILE> bs=1000 skip=1" will incorrectly generate whole last line

- read after lseek on into middle of last line will output expected rest of
 last line but then repeat whole last line once again. 

- If .show() function generates multi-line output following bash script will never finish.

 $ q=;while read -r r;do echo "$((++q)) $r";done < AFFECTED_FILE

Link: https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?id=206283__;!!GqivPVa7Brio!Jq0fspl3uRa_Xiu-ifjc60ajewi308CVdv8Dq-9kHzOjkRYAd1YKlDU1a1TQdmMTBPWO8g$ 

Vasily Averin (4):
  lockres_seq_next should increase position index
  ocfs2_dlm_seq_next should increase position index
  nst_seq_next should increase position index
  sc_seq_next should increase position index

 fs/ocfs2/cluster/netdebug.c | 2 ++
 fs/ocfs2/dlm/dlmdebug.c     | 1 +
 fs/ocfs2/dlmglue.c          | 1 +
 3 files changed, 4 insertions(+)

-- 
1.8.3.1
