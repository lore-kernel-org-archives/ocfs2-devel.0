From: tristan.ye <tristan.ye@oracle.com>
Date: Mon, 09 Mar 2009 14:54:44 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2: two bug fixes about xattr
	and	inline-data
In-Reply-To: <20090309064711.GB27610@mail.oracle.com>
References: <49ADF2FB.6060503@oracle.com>
	<20090305023617.GA18729@mail.oracle.com>
	<1236572226.6816.30.camel@tristan-laptop.cn.oracle.com>
	<49B4A1B8.10806@oracle.com>
	<1236575084.6816.35.camel@tristan-laptop.cn.oracle.com>
	<49B4AC58.4090400@oracle.com>
	<1236579270.6816.39.camel@tristan-laptop.cn.oracle.com>
	<49B4B8B8.7030108@oracle.com> <20090309064711.GB27610@mail.oracle.com>
Message-ID: <1236581684.6816.45.camel@tristan-laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, 2009-03-08 at 23:47 -0700, Joel Becker wrote:
> On Mon, Mar 09, 2009 at 02:35:36PM +0800, Tiger Yang wrote:
> > I found these two bugs in latest mainline kernel not other branch.
> 
> 	The bugs should still be in cacheme - cacheme doesn't change
> the inline data code.

Fairly strange, I've already done the tests on cacheme branch, no such
bugs happened to me...

Tristan

> 
> Joel
> 
