From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 22 Jul 2010 21:27:41 +0800
Subject: [Ocfs2-devel] [PATCH V2] Fix the nested PR lock calling issue
In-Reply-To: <AANLkTimRLhsueTsr-eh_MMyWHqwCxkPF0YLaLYp3E3sr@mail.gmail.com>
References: <20100721144805.GA12822@linux-jjzhang>
	<20100721151701.GA3579@laptop.jp.oracle.com>
	<20100721160542.GA19036@linux-jjzhang>
	<4C473BE2.8000608@oracle.com>
	<20100722052611.GA13238@linux-jjzhang>
	<20100722101118.GA3486@laptop.jp.oracle.com>
	<AANLkTimRLhsueTsr-eh_MMyWHqwCxkPF0YLaLYp3E3sr@mail.gmail.com>
Message-ID: <20100722132741.GA3757@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

My reply is mainly to Sunil. Sorry for the confusing!
Your patch is good if we need the _ocfs2_get_acl and don't touch
ocfs2_get_acl_nolock :)

regards,
wengang. 
On 10-07-22 21:16, Jiaju Zhang wrote:
> On Thu, Jul 22, 2010 at 6:11 PM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
> > ocfs2_get_acl_nolock() has the same functionality just with different
> > arguments. And we can't replace it with the new _ocfs2_get_acl() for the
> > call in ocfs2_init_acl().
> 
> I don't mean replace ocfs2_get_acl_nolock() with _ocfs2_get_acl().
> What I'm just thinking is if we have the necessity of rename current
> ocfs2_get_acl_nolock() with _ocfs2_get_acl(), and also rename current
> _ocfs2_get_acl() in my patch with ocfs2_get_acl_nolock(). Anyway, it
> is just a very minor change, I'm not sure if we should do it or not.
> 
> > So I am wondering if we really need the new _ocfs2_get_acl().
> 
> IMO, we may need _ocfs2_get_acl(). It will make the code looks clearer;)
> 
> Thanks,
> Jiaju
