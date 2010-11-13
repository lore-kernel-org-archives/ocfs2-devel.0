From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Sat, 13 Nov 2010 13:03:21 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Introduce ocfs2_recover_node
In-Reply-To: <AANLkTikzZnCA4aK_tXMLacoFjwQ9aCiuSiZs3nPvJ08G@mail.gmail.com>
References: <AANLkTikLJODb51xYJdcs3JmoYvJLETDMpUutxXh8ZpF1@mail.gmail.com>
	<20101112021614.GA2316@laptop.jp.oracle.com>
	<AANLkTikzZnCA4aK_tXMLacoFjwQ9aCiuSiZs3nPvJ08G@mail.gmail.com>
Message-ID: <20101113050321.GA2252@laptop>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 10-11-12 13:22, Goldwyn Rodrigues wrote:
> Hi Wengang,
> 
> Thanks for the review.
> 
> On Thu, Nov 11, 2010 at 8:16 PM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
> > On 10-11-11 19:01, Goldwyn Rodrigues wrote:
> >> ocfs2_recover_node is a new data structure to include all information required
> >> to recover one node. The structure is maintained as a list in the super block.
> >>
> >> ocfs2_recover_node replaces the recovery_map
> >>
> >> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
> >> - ? ? ? ? ? ? ? ? ? ? rm_quota[rm_quota_used++] = slot_num;
> >> + ? ? ? ? ? ? ? ? ? ? rm_quota[rm_quota_used++] = rn->rn_slot_num;
> >>
> >> - ? ? ? ? ? ? status = ocfs2_recover_node(osb, node_num, slot_num);
> >> + ? ? ? ? ? ? status = ocfs2_recover_one_node(rn);
> >> ?skip_recovery:
> >> ? ? ? ? ? ? ? if (!status) {
> >> - ? ? ? ? ? ? ? ? ? ? ocfs2_recovery_map_clear(osb, node_num);
> >> + ? ? ? ? ? ? ? ? ? ? ocfs2_recovery_map_clear(osb, rn);
> >
> > kfree with spinlocked here.
> >
> 
> What is the problem with that?

hm... seems no block in kfree() in current code.
please ignore that comment!

regards,
wengang.
