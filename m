From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 17 Dec 2008 10:52:39 -0800
Subject: [Ocfs2-devel] [PATCH 1/9] ocfs2/hb: Exposes list of
 heartbeating nodes via debugfs
In-Reply-To: <1229504605.411.5.camel@tristan-laptop.cn.oracle.com>
References: <1229471363-15887-1-git-send-email-sunil.mushran@oracle.com>	
	<1229471363-15887-2-git-send-email-sunil.mushran@oracle.com>
	<1229504605.411.5.camel@tristan-laptop.cn.oracle.com>
Message-ID: <49494A77.6020600@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The inode arg comes by way of the struct file_operations' open() and 
release()
function prototypes. On a typical file system, the inode points to the 
entity
that that operation is for. In synthetic file systems, however, the 
inode is at
times superfluous because the entity being worked could be fixed. For 
example here
we are returning a list of heartbeating nodes. That's the reason it is 
not being
used. But that does not mean we can do away with it because we are still 
using
file_ops infrastructure.

tristan.ye wrote:
>> +static int o2hb_debug_open(struct inode *inode, struct file *file)
>>     
> Just be curious that why the arg 'inode' kept here since it never be
> refered in below func body.
> so as the func o2hb_debug_release()
