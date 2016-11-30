From: Eric Ren <zren@suse.com>
Date: Wed, 30 Nov 2016 16:37:17 +0800
Subject: [Ocfs2-devel] [PATCH 0/7] quota: Use s_umount for quota on/off
	serialization
In-Reply-To: <1479975162-24060-1-git-send-email-jack@suse.cz>
References: <1479975162-24060-1-git-send-email-jack@suse.cz>
Message-ID: <9ec493f7-9fdb-d8e1-d2ea-468ce1d3e401@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>, mfasheh@versity.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com

Hello,

On 11/24/2016 04:12 PM, Jan Kara wrote:
> Hello,
>
> this patch set changes quota code to use s_umount semaphore for serialization
> of quota on/off operations among each other and with other quotactl and
> quota writeback operations. So far we have used dedicated dqonoff_mutex but
> that triggered lockdep warnings during fs freezing and also unnecessarily
> serialized some quotactl operations.
>
> Al, any objections to patch 1/7 exporting functionality to get superblock with
> s_umount in exclusive mode? Alternatively I could add a wrapper around
> get_super_thawed() in quota code to drop s_umount & get it in exclusive mode
> and recheck that superblock didn't get unmounted / frozen but what I did here
> looked cleaner to me.
>
> OCFS2 guys, it would be good if you could test ocfs2 quotas with this patch set
> in some multi-node setup (I have tested just with a single node), especially
> whether quota file recovery for other nodes still works as expected. Thanks.

With this patch set, the quota file recovery works well for ocfs2 on multiple nodes.

Tested-by:    Eric Ren <zren@suse.com>

Thanks,
Eric
>
> If nobody objects, I'll push these changes through my tree to Linus.
>
> 								Honza
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
