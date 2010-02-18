From: srinivas eeda <srinivas.eeda@oracle.com>
Date: Wed, 17 Feb 2010 17:55:15 -0800
Subject: [Ocfs2-devel] [PATCH 3/3] o2net: correct keepalive message
	protocol
In-Reply-To: <20100218014915.GA5215@mail.oracle.com>
References: <1264740671-908-1-git-send-email-srinivas.eeda@oracle.com>
	<1264740671-908-4-git-send-email-srinivas.eeda@oracle.com>
	<20100217055641.GI13798@mail.oracle.com>
	<4B7C345E.6000504@oracle.com>
	<20100218014915.GA5215@mail.oracle.com>
Message-ID: <4B7C9E03.4020603@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Yea, they don't expect/wait for a response for keep alive message.

On 2/17/2010 5:49 PM, Joel Becker wrote:
> On Wed, Feb 17, 2010 at 10:24:30AM -0800, Srinivas Eeda wrote:
>   
>> Each node that has this patch would send a O2NET_MSG_KEEP_REQ_MAGIC
>> every 2 seconds(default). So, nodes without this patch would always
>> receive a heartbeat message every 2 seconds.
>>     
>
> 	So, old nodes do not care if they never receive RESP_MAGIC as
> long as they got some other message?
>
> Joel
>
>   
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20100217/09dedd52/attachment.html 
