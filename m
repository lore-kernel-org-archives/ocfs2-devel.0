From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 19 Jun 2009 21:57:54 -0700
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: Disable orphan scanning for
	local and hard-ro mounts
In-Reply-To: <20090620044129.GA1993@mail.oracle.com>
References: <1245455599-23348-1-git-send-email-sunil.mushran@oracle.com>
	<1245455599-23348-4-git-send-email-sunil.mushran@oracle.com>
	<20090620044129.GA1993@mail.oracle.com>
Message-ID: <452E36BE-C1F3-4233-B57C-B62E6EEC6AEE@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Good catch.

On Jun 19, 2009, at 9:41 PM, Joel Becker <Joel.Becker@oracle.com> wrote:

> On Fri, Jun 19, 2009 at 04:53:19PM -0700, Sunil Mushran wrote:
>> @@ -2392,11 +2398,13 @@ void ocfs2_orphan_scan_unlock(struct  
>> ocfs2_super *osb, u32 seqno, int ex)
>>    struct ocfs2_orphan_scan_lvb *lvb;
>>    int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
>>
>> -    lockres = &osb->osb_orphan_scan.os_lockres;
>> -    lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
>> -    lvb->lvb_version = OCFS2_ORPHAN_LVB_VERSION;
>> -    lvb->lvb_os_seqno = cpu_to_be32(seqno);
>> -    ocfs2_cluster_unlock(osb, lockres, level);
>> +    if (!ocfs2_is_hard_readonly(osb) && !ocfs2_mount_local(osb)) {
>> +        lockres = &osb->osb_orphan_scan.os_lockres;
>> +        lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
>> +        lvb->lvb_version = OCFS2_ORPHAN_LVB_VERSION;
>> +        lvb->lvb_os_seqno = cpu_to_be32(seqno);
>> +        ocfs2_cluster_unlock(osb, lockres, level);
>
>    This should only be setting the LVB if the level was EX.
>
> Joel
>
> -- 
>
> "Up and down that road in our worn out shoes,
> Talking bout good things and singing the blues."
>
> Joel Becker
> Principal Software Developer
> Oracle
> E-mail: joel.becker at oracle.com
> Phone: (650) 506-8127
