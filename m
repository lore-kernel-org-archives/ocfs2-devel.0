From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Tue Feb 17 16:46:46 2004
Subject: [Ocfs2-devel] osb->curr_trans_id
Message-ID: <50D19C3AC815734C9E19FE4C4F6128A602A56902@orsmsx403.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

So I was looking at the TODO list and I see these two entries:

* get rid of osb->curr_trans_id as it was never used (always zero)

* get rid of all the:
        changeSeqNum = osb->curr_trans_id;
        DISK_LOCK_SEQNUM(fe) = changeSeqNum;
  code as it is equally useless.

So I was going to tackle this but I was wondering if there was anything
I should look out for.

From my quick perusing of the code it seems fairly simple but I am
probably missing something.

So before submitting a "dumb" patch I thought I see if there was any
comments on this.

Thanks,
John
