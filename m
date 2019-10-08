From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Tue, 8 Oct 2019 10:19:05 +0800
Subject: [Ocfs2-devel] Potential NULL pointer deference in ocfs2
In-Reply-To: <CABvMjLTbBJ-9JrLDi=4B=2MVFCFv95tarS=qe10Pte+=HYSpbw@mail.gmail.com>
References: <CABvMjLTbBJ-9JrLDi=4B=2MVFCFv95tarS=qe10Pte+=HYSpbw@mail.gmail.com>
Message-ID: <379d05aa-b619-f008-4ded-78bc11c411ae@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 19/10/8 03:09, Yizhuo Zhai wrote:
> Hi All:
> 
> fs/ocfs2/cluster/heartbeat.c:
> 
> Inside function o2hb_region_start_block_store(), to_o2hb_region()
> could return NULL,however, the return value of to_o2hb_region() is not
> checked and get
> used. This could potentially be unsafe.
> 
Umm...config item won't be NULL, it is initialized when module
ocfs2_nodemanager is loaded.

Thanks,
Joseph
