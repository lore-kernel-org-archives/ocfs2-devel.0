From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 27 Jun 2013 15:08:10 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: llseek requires to ocfs2 inode
 lock for the file in SEEK_END
In-Reply-To: <CAEeiSHV=3DBBJ1mweEgyxWRgsA9O8C-25_FTPMxyDbatoX0Fkw@mail.gmail.com>
References: <51C2BC1F.2010106@huawei.com>
	<20130626141803.a67cb8e4ca38a9ef2967a448@linux-foundation.org>
	<51CB9338.3050408@huawei.com>
	<20130626182536.c319334d.akpm@linux-foundation.org>
	<51CB9A81.2000007@huawei.com>
	<CAEeiSHV=3DBBJ1mweEgyxWRgsA9O8C-25_FTPMxyDbatoX0Fkw@mail.gmail.com>
Message-ID: <20130627150810.2d22d158a1f0bed8482a27d8@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 26 Jun 2013 20:34:19 -0700 Sunil Mushran <sunil.mushran@gmail.com> wrote:

> AFAIR, this behavior has been there since day 1 and changing it will impact
> performance negatively. I would recommend against making this change for
> one app.

Well, it's a bug fix isn't it?  SEEK_END on a 15k file is presently returning
10k.

Obviously tradeoffs are involved - is there any way in which this
behaviour can be fixed without serious performance damage?
