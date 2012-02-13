From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 13 Feb 2012 12:41:33 -0800
Subject: [Ocfs2-devel] [patch] ocfs2: cleanup error handling in
	o2hb_alloc_hb_set()
In-Reply-To: <20120213202923.GL4141@mwanda>
References: <20120213135047.GA10683@elgon.mountain>
	<20120213200408.GA22314@dhcp-172-17-9-228.mtv.corp.google.com>
	<20120213202923.GL4141@mwanda>
Message-ID: <4F39757D.4030101@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 02/13/2012 12:29 PM, Dan Carpenter wrote:
> On Mon, Feb 13, 2012 at 12:04:09PM -0800, Joel Becker wrote:
>> On Mon, Feb 13, 2012 at 04:50:47PM +0300, Dan Carpenter wrote:
>>> If "ret" is NULL, then "hs" is also NULL, so there is no need to free
>>> it.  config_group_init_type_name() can't fail if the name ("heartbeat"
>>> in this case) is less than CONFIGFS_ITEM_NAME_LEN (20) characters long
>>> so we can just remove this error handling code.
>>
>> 	Is there a problem we're fixing here?  We can make all sorts of
>> arguments about single-exit functions vs immediate returns, but if there
>> isn't a problem, I'm not sure what we gain by code churn.
>
> It's a static checker thing.  It's either an unneeded NULL check or
> a check on the wrong variable depending on how you look at it.
> Recently, I've been sending a lot of patches to remove unneeded NULL
> checks for static checkers.  I try to fix the mistakes that are
> harmless so that the real bugs aren't drowned out in noise.

In that case, ACK.
