From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 1 Mar 2018 15:29:31 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: don't handle migrate lockres
 if already in shutdown
In-Reply-To: <5A97F41E.5090800@huawei.com>
References: <5A97C734.5020705@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373F292B279@H3CMLB12-EX.srv.huawei-3com.com>
	<5A97F41E.5090800@huawei.com>
Message-ID: <20180301152931.f878871c36e9e92e03529685@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 1 Mar 2018 20:37:50 +0800 piaojun <piaojun@huawei.com> wrote:

> Hi Changwei,
> 
> Thanks for your quick reply, please see my comments below.
> 
> On 2018/3/1 17:39, Changwei Ge wrote:
> > Hi Jun,
> > 
> > On 2018/3/1 17:27, piaojun wrote:
> >> We should not handle migrate lockres if we are already in
> >> 'DLM_CTXT_IN_SHUTDOWN', as that will cause lockres remains after
> >> leaving dlm domain. At last other nodes will get stuck into infinite
> >> loop when requsting lock from us.
> >>
> >>      N1                             N2 (owner)
> >>                                     touch file
> >>
> >> access the file,
> >> and get pr lock
> >>
> >> umount
> >>
> > 
> > Before migrating all lock resources, N1 should have already sent 
> > DLM_BEGIN_EXIT_DOMAIN_MSG in dlm_begin_exit_domain().
> > N2 will set ->exit_domain_map later.
> > So N2 can't take N1 as migration target.
> Before receiveing N1's DLM_BEGIN_EXIT_DOMAIN_MSG, N2 has picked up N1 as
> the migrate target. So N2 will continue sending lockres to N1 even though
> N1 has left domain. Sorry for making you misunderstanding, I will give a
> more detailed description.
> 
>     N1                             N2 (owner)
>                                    touch file
> 
> access the file,
> and get pr lock
> 
>                                    begin leave domain and
>                                    pick up N1 as new owner
> 
> begin leave domain and
> migrate all lockres done
> 
>                                    begin migrate lockres to N1
> 
> end leave domain, but
> the lockres left
> unexpectedly, because
> migrate task has passed

If someone asked a question then this is a sign that the changelog was
missing details.  So please do send along a v2 with a more
comprehensive changelog.
