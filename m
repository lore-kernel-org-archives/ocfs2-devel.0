From: tristan <tristan.ye@oracle.com>
Date: Wed, 24 Mar 2010 09:10:13 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Teach truncating and
 punching-hole codes to handle fastsymlink.
In-Reply-To: <20100323195224.GA31783@mail.oracle.com>
References: <1269331484-21262-1-git-send-email-tristan.ye@oracle.com>
	<20100323195224.GA31783@mail.oracle.com>
Message-ID: <4BA96675.80506@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Tue, Mar 23, 2010 at 04:04:44PM +0800, Tristan Ye wrote:
>> Fast symlink can be treated the same way as inline file for truncating
>> and hole punching, since the mechanism is quite simliar per se.
>>
>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>
> 	The patch looks good, with perhaps a bit over-zealous
> parentheses ;-)  Is this fixing a bug someone has hit?

Not exactly,

Sunil reported such a bug from userspace in libocfs2, I suddenly 
realised that we could also do the same in fs.

Tristan.

>
> Joel
>
>
