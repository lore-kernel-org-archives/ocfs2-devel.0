From: Changwei Ge <ge.changwei@h3c.com>
Date: Wed, 11 Oct 2017 00:48:34 +0000
Subject: [Ocfs2-devel] mmotm 2016-08-02-15-53 uploaded
References: <57a124aa.eJmVCvd1SOHlQ1X8%akpm@linux-foundation.org>
	<CAGF4SLgi6jgtxbqtTEjL8FGXUHHsSm6KeoVqANLt3LB6OTBboA@mail.gmail.com>
	<20171010123749.2c59f3b762b3c0b33e80a67d@linux-foundation.org>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373CED68187@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Vitaly Mayatskih <v.mayatskih@gmail.com>
Cc: "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "mhocko@suse.cz" <mhocko@suse.cz>, "broonie@kernel.org" <broonie@kernel.org>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, piaojun <piaojun@huawei.com>, Joseph Qi <joseph.qi@huawei.com>, Jiufei Xue <xuejiufei@huawei.com>, Mark Fasheh <mfasheh@suse.de>, Joel Becker <jlbec@evilplan.org>, Junxiao Bi <junxiao.bi@oracle.com>

Hi Andrew and Vitaly,

I do agree that patch ee8f7fcbe638 ("ocfs2/dlm: continue to purge 
recovery lockres when recovery master goes down", 2016-08-02) introduced 
an issue. It makes DLM recovery can't pick up a new master for an 
existed lock resource whose owner died seconds ago.

But this patch truly solves another issue.
So I think we can't just revert this patch but to give a fix to it.

Thanks,
Changwei

On 2017/10/11 3:38, Andrew Morton wrote:
> On Tue, 10 Oct 2017 14:06:41 -0400 Vitaly Mayatskih <v.mayatskih@gmail.com> wrote:
> 
>> * ocfs2-dlm-continue-to-purge-recovery-lockres-when-recovery
>> -master-goes-down.patch
>>
>> This one completely broke two node cluster use case: when one node dies,
>> the other one either eventually crashes (~4.14-rc4) or locks up (pre-4.14).
> 
> Are you sure?
> 
> Are you able to confirm that reverting this patch (ee8f7fcbe638b07e8)
> and only this patch fixes up current mainline kernels?
> 
> Are you able to supply more info on the crashes and lockups so that the
> ocfs2 developers can understand the failures?
> 
> Thanks.
> 
