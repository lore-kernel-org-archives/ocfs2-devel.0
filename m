From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 20 Dec 2016 14:51:26 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix crash caused by stale lvb with
	fsdlm plugin
In-Reply-To: <6ddf36d1-9e2b-f094-77a4-6ec6d6661dc2@gmail.com>
References: <1481275846-6604-1-git-send-email-zren@suse.com>
	<7dbdc1d8-f1c5-c6bf-0614-1d8f03f0e3f0@gmail.com>
	<66edad7f-6c83-a5e0-aab3-d3a034667042@suse.com>
	<6ddf36d1-9e2b-f094-77a4-6ec6d6661dc2@gmail.com>
Message-ID: <20161220145126.5ee33b840f9967aae2e63806@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Qi <jiangqi903@gmail.com>
Cc: Eric Ren <zren@suse.com>, ocfs2-devel@oss.oracle.com, mfasheh@versity.com, jlbec@evilplan.org, teigland@redhat.com, ghe@suse.com, junxiao.bi@oracle.com, linux-kernel@vger.kernel.org

On Mon, 19 Dec 2016 17:55:06 +0800 Joseph Qi <jiangqi903@gmail.com> wrote:

> > I'd like to see this quick and small fix to be merged at this moment, 
> > because this issue is little emergency for us.
> > Anyway, we can supersede this one easily if someone familiar with o2cb 
> > works out a patch for o2cb in the future.
> >
> > Does this sounds good to you?
> 
> Fine.
> Reviewed-by: Joseph Qi <jiangqi903@gmail.com>

I'll add cc:stable to this one so the fix gets backported into older
kernels.
