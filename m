From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 4 Jan 2016 16:35:32 -0800
Subject: [Ocfs2-devel] [PATCH] add OCFS2_LOCK_IGNORE_BLOCKED arg_flags
 to ocfs2_cluster_lock() to prevent hang
In-Reply-To: <568ADCC1.7090503@oracle.com>
References: <1450828550-23168-1-git-send-email-tariq.x.saeed@oracle.com>
	<20151230003456.GR11072@wotan.suse.de>
	<568ADCC1.7090503@oracle.com>
Message-ID: <20160105003532.GA819@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jan 04, 2016 at 12:57:37PM -0800, Tariq Saeed wrote:
> 
> On 12/29/2015 04:34 PM, Mark Fasheh wrote:
> > NACK - as I explained earlier on this list we need to refactor the code to
> Not sure how things work in the open source world. Is refactoring to be 
> picked by
> somebody soon?

No problem, A couple explanations  / notes:

1) CC me with your patches (someone had to point the last one out to me).

I'll get to reviewing most things but if you CC me then it can happen
sooner.


2) You are fixing the bug and sending the patches. We usually expect the
sender to incorporate feedback into their patch so the answer would be that
you get to to the refactoring :)

If you need to make small changes to the VFS to let this happen (sometimes
we might want 'nolock' variants of funtions, etc), do them in seperate
patches and send them along with your changes.

Hope this helps,
	--Mark

--
Mark Fasheh
