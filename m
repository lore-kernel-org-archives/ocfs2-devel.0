From: Coly Li <coly.li@suse.de>
Date: Wed, 31 Mar 2010 14:11:23 +0800
Subject: [Ocfs2-devel] question for lvb->lvb_igeneration
In-Reply-To: <20100331024449.GA2184@laptop.oracle.com>
References: <4BB2A0C2.7010305@suse.de>
	<20100331024449.GA2184@laptop.oracle.com>
Message-ID: <4BB2E78B.9030909@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 03/31/2010 10:44 AM, Wengang Wang Wrote:
> Hi Coly,
> 
> Let me try to comment.
>> My question is, is it possible that same inode's lvb->lvb_size and di->i_size can be different ? And if an inode lvb is
>> really trustable when ocfs2_meta_lvb_is_trustable() returns 1 ?
> 
> I think lvb is trustable. If di->i_size mismatches lvb->lvb_size, either
> we are taking a wrong lvb or the di is stale.
>>
>> The reason why I ask this question, is because of bnc#591039 (https://bugzilla.novell.com/show_bug.cgi?id=591039).

Hi Wengang,

Thanks for the replying:-)
Another question is, in which cases when di is staled, di->i_size is different to lvb->lvb_isize ? IMHO, update the on
disk inode will take an EX lock which will update lvb->lvb_isize as well ?

-- 
Coly Li
SuSE Labs
