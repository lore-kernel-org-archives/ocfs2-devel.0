From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 01 Sep 2009 16:47:41 +0800
Subject: [Ocfs2-devel] [PATCH 06/14] ocfs2: Set the xattr name+value
	pair in one place
In-Reply-To: <20090901083047.GC3826@mail.oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-7-git-send-email-joel.becker@oracle.com>
	<4A9CCE33.2070506@oracle.com>
	<20090901083047.GC3826@mail.oracle.com>
Message-ID: <4A9CDFAD.5060603@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> On Tue, Sep 01, 2009 at 03:33:07PM +0800, Tao Ma wrote:
>> Joel Becker wrote:
>>> +	rc = ocfs2_xa_has_space(loc, xi);
>>> +	if (rc)
>>> +		goto out;
>> could you please add some comments here or change the function name.
>> when I read ocfs2_xa_has_space, I always think that "if we have
>> space, goto out". But actually we get 0 here if we have space.
> 
> 	A very good point.  It really should be ocfs2_xa_space_needed().
> Does that work?
actually your function just return either -ENOSPC, -EIO or 0.
And we go ahead when we get 0. so maybe ocfs2_xa_check_space? So <0 
means we meet with some errors and 0 means OK.

Regards,
Tao
