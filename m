From: Tristan Ye <tristan.ye@oracle.com>
Date: Wed, 27 Apr 2011 22:06:02 -0000
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2/move_extents: Validate moving
 goal after the adjustment.
In-Reply-To: <20110611195742.GA2141@mako-laptop>
References: <20110611195742.GA2141@mako-laptop>
Message-ID: <4DF42CEF.6020704@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/12/2011 03:57 AM, Mariusz Kozlowski wrote:
> Hi,
> 
>   I think this one (ea5e1675 upstream) is wrong. Validation was moved
> before 'bg' was assinged any sane value. Also 'bg' is defined with NULL
> now so it hides real problem that 'bg' is used uninitialized. So currently
> as 'bg' is NULL from the begining it will blow up with null pointer
> dereference somewhere around test in line 489:


You're definitely correct, I'm blaming myself for not making things in
order after moving the validation logic backwards a bit, thanks so much
for pointing this out.

Tristan.

> 
> 489:        if (range->me_goal == le64_to_cpu(bg->bg_blkno))
> 490:	                range->me_goal += c_to_b;
> 
> Sorry for reply with no context but I'm not subscribed to ocfs2-devel.
