From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 25 Aug 2014 13:41:45 +0800
Subject: [Ocfs2-devel] A deadlock when system do not has sufficient
	memory
In-Reply-To: <CAEeiSHWiPZHKC5gwLTuuZAm3xUeGT48BLNs97qdUgZSMM+AFZQ@mail.gmail.com>
References: <53F41CAE.2040204@huawei.com> <53F6FFB7.1090305@huawei.com>
	<CAEeiSHVP60=zNcP-Q2bCD_BdD3g8v1a__Vyn4ZMF_8Z97cpE8g@mail.gmail.com>
	<53FA99FD.1090008@huawei.com>
	<CAEeiSHWiPZHKC5gwLTuuZAm3xUeGT48BLNs97qdUgZSMM+AFZQ@mail.gmail.com>
Message-ID: <53FACC99.8070701@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2014/8/25 13:00, Sunil Mushran wrote:
> Functions in dlmdomain.c are only triggered during mount. So they cannot trigger the deadlock as described above in this thread. I would leave them as is.
> 
It is possible if mounts multiple volumes on each node.

> On Aug 24, 2014 7:06 PM, "Xue jiufei" <xuejiufei at huawei.com <mailto:xuejiufei@huawei.com>> wrote:
> 
>     Hi Sunil,
>     On 2014/8/23 1:08, Sunil Mushran wrote:
>     > Allocs made via GFP_NOFS, by definition, should not trigger any reclaim from the fs.
>     > So this situation should never arise. That's why all allocs in the dlm have NOFS.
>     >
>     Thanks for your reply. I haven't noticed that before. So I think
>     dlm_query_region_handler() should also use GFP_NOFS instead of GFP_KERNEL,
>     right?
> 
>     Thanks.
>     Xuejiufei
>     >
>     > _______________________________________________
>     > Ocfs2-devel mailing list
>     > Ocfs2-devel at oss.oracle.com <mailto:Ocfs2-devel@oss.oracle.com>
>     > https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>     >
> 
> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
