From: Alexander Beregalov <a.beregalov@gmail.com>
Date: Tue, 4 Nov 2008 23:59:09 +0300
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix printk format warnings in
	xattr.c
In-Reply-To: <20081104181848.GS15154@wotan.suse.de>
References: <20081104110645.GB12456@orion>
	<20081104181848.GS15154@wotan.suse.de>
Message-ID: <a4423d670811041259r2acdcc9bgbd52e0da2f58b778@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

2008/11/4 Mark Fasheh <mfasheh@suse.com>:
> On Tue, Nov 04, 2008 at 02:06:45PM +0300, Alexander Beregalov wrote:
>>
>>
>> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
>> ---
>>
>>  fs/ocfs2/xattr.c |   34 ++++++++++++++++++++--------------
>>  1 files changed, 20 insertions(+), 14 deletions(-)
>
> Hmm, can you check
> http://git.kernel.org/?p=linux/kernel/git/mfasheh/ocfs2.git;a=blobdiff;f=fs/ocfs2/xattr.c;h=70baffeb1812771620bf1a9d08f1e76d48927f68;hp=f3ea7efb48c63a1dff92f8b0e7eb33f12d02a9d9;hb=5b294cb920e60b8c271cfeabba056376cce7441f;hpb=c2e2c581ace8de4a9cff733bc54e3c5677ff3c37
>
> and make sure I don't already have these...
Yes, you have fixed it already.

But what branch is it? I can not fetch the last fix using master or
linux-next branches.
http://git.kernel.org/?p=linux/kernel/git/mfasheh/ocfs2.git;a=history;f=fs/ocfs2;hb=5b294c
