From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 04 Feb 2010 11:36:30 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Plugs race between the dc thread
 and an unlock ast message
In-Reply-To: <20100204102729.GA4339@laptop.oracle.com>
References: <1265221014-10591-1-git-send-email-sunil.mushran@oracle.com>
	<20100204102729.GA4339@laptop.oracle.com>
Message-ID: <4B6B21BE.10708@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Wengang Wang wrote:
> By "unlock ast message", do you meant
> ocfs2_locking_ast()->ocfs2_generic_handle_downconvert_action()?
>
> If yes, 
> if l_blocking did not changed before ocfs2_generic_handle_downconvert_action(),
> when l_level is set with a lower value, l_blocking must change.
> So why we need to check l_level?

I meant ocfs2_unlock_ast. Specifically cancel convert. That is one case
that does not change l_blocking directly.

However, that does not change the l_level too. So I am unsure what sequence
of asts and basts (multiple ofcourse) can lead to this situation.

But the patch looks reasonable even if I cannot state the precise scenario
that leads to it.

David is rerunning the test. We'll know the results by tomorrow.
