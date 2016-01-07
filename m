From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Thu, 07 Jan 2016 14:38:11 -0800
Subject: [Ocfs2-devel] [PATCH] revert to using ocfs2_acl_chmod to avoid
 inode cluster lock hang
In-Reply-To: <568DD2BD.8010503@oracle.com>
References: <1452047231-30569-1-git-send-email-tariq.x.saeed@oracle.com>	<568C9B0F.7040500@oracle.com>
	<568DD2BD.8010503@oracle.com>
Message-ID: <568EE8D3.9080606@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 01/06/2016 06:51 PM, Tariq Saeed wrote:
> On 01/05/2016 08:41 PM, Junxiao Bi wrote:
>> This fixed part of the deadlock. There is another part.
>> ocfs2_mknod()->posix_acl_create()->ocfs2_iop_get_acl()
> Right. It used to be:  ocfs2_mknod -> ocfs2_init_acl ->
> ocfs2_get_acl_nolock.
>
> Thanks
> -Tariq
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
