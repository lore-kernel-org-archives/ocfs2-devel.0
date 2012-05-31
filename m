From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Wed, 30 May 2012 18:18:12 -0700
Subject: [Ocfs2-devel] [PATCH] Fix waiting status race condition in dlm
	recovery
In-Reply-To: <4FC56CA5.8040902@oracle.com>
References: <1337925202-13086-1-git-send-email-xiaowei.hu@oracle.com>
	<CAEeiSHXcaKXi7Qm5vLBmTp2CjiB7DCrUee5qmr03YpuJbzP5yg@mail.gmail.com>
	<4FC56CA5.8040902@oracle.com>
Message-ID: <CAEeiSHWkhD8x8nrix2+Wc1nesH8CExU6kA10nCH0J1nCwUaDtg@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, May 29, 2012 at 5:41 PM, Xiaowei <xiaowei.hu@oracle.com> wrote:
> On 05/30/2012 06:09 AM, Sunil Mushran wrote:
> I would suggest exploring adding this in dlm hb down event. Checking live
> map all
> over the place is hacky. We do it more than we should right now. Let's not
> add to the
> mess.
>
> HI Sunil,
>
> Do you mean we should clear the bit in domain map in dlm hb down event
> directly when the node down
> and check with dlm_is_node_dead at here?
> Or how could we explore and ensure the node is alive during the whole
> migrate process?One node could die even after it sends out one locks package
> and before the next if there were too many locks on that lockres.

dlm hb down event is triggered when a node is declared dead. That's where we
clean up pending mles, etc. You can add a check for recovery and add logic to
change the reco state for that node there.
