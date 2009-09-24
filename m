From: jeff.liu <jeff.liu@oracle.com>
Date: Thu, 24 Sep 2009 10:15:12 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2-devel: remove an invalid single
 quotation marks from the mlog string in dlm_unregister_domain()
In-Reply-To: <4ABA08BB.9010601@oracle.com>
References: <> <1253697004-23982-1-git-send-email-jeff.liu@oracle.com>
	<4ABA08BB.9010601@oracle.com>
Message-ID: <4ABAD630.5050107@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Wengang,

Yes, I think so.

I also found another one in dlmmaster.c:3286 which is :" All UNKNOWN 
lockres' are sent to..."


Thanks,
Jeff


Wengang Wang ??:
> Hi Jeff,
>
> Jeff Liu wrote:
>> "Following lockres' are still on the "
>> ^ here
>>
>
> I guess "lockres'" means there could be more than one lockres there.
