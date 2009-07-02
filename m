From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 02 Jul 2009 07:32:23 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] [ocfs2-devel] NET_MAX_PAYLOAD_BYTES
 typo?
In-Reply-To: <4A4D32FD.6030005@oracle.com>
References: <> <1246543998-32316-1-git-send-email-jeff.liu@oracle.com>
	<4A4D32FD.6030005@oracle.com>
Message-ID: <4A4CC4F7.5030909@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

TaoMa wrote:
>> I've read fs/ocfs2/dlm/dlmcommon.h to study the structure of dlm_migratable_lockres.
>> However, I may find a typo for the DLM_MIG_LOCKRES_MAX_LEN,
>> the NET_MAX_PAYLOAD_BYTES should be O2NET_MAX_PAYLOAD_BYTES, I think.
>> In comments, the sizeof(net_msg) should be sizeof(o2net_msg) by referring to fs/ocfs2/cluster/tcp.h.
>>   
> yeah, NET_MAX_PAYLOAD_BYTES here should be O2NET_MAX_PAYLOAD_BYTES and I 
> guess the reason why we never find this error is because we never use 
> DLM_MIG_LOCKRES_RESERVED by now.

And if we have not used it by now, chances are we never will. Maybe just
remove it. But let it be for the time being. I'll ask Kurt if he 
remembers what
the reasoning was.

> btw, there is another NET_MAX_PAYLOAD_BYTES you forget to change in 
> fs/ocfs2/dlm/dlmcommon.h
>   
