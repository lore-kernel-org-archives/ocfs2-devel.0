From: Sunil Mushran <sunil.mushran@ORACLE.COM>
Date: Wed, 21 Apr 2010 11:32:37 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Add macro
 OCFS2_VOL_UUIDSTR_LEN in ocfs2_fs.h
In-Reply-To: <4BCE5792.8010104@oracle.com>
References: <1271746743-17653-1-git-send-email-tristan.ye@oracle.com>	<20100420223223.GB9423@mail.oracle.com>
	<4BCE2C03.5000506@oracle.com> <4BCE2F29.3060104@oracle.com>
	<4BCE5792.8010104@oracle.com>
Message-ID: <4BCF44C5.6050701@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

tristan wrote:
> Sunil Mushran wrote:
>> ok. So how about we remove this #define totally and have
>> the ioctl interface return the binary uuid. The o2info tool
>> can convert do the conversion.
>
> But... returning binary uuid from o2info was not that easy, ocfs2 
> in-memory super_block osb only successfully initialized the osb->uuid, 
> while did nothing to uuid_str, I remembered we've been discussing on 
> that issue:
>
> http://oss.oracle.com/pipermail/ocfs2-devel/2009-November/005514.html
>
>
> That patch was not adopted, and we're still using uuid_str in most 
> places.

Ok. Thanks for reminding me.

It appears we already have OCFS2_TEXT_UUID_LEN in stack_user.c. That's a
clean name. In the patch below, I have moved it to ocfs2.h so that we can
use it elsewhere.

http://oss.oracle.com/~smushran/0001-ocfs2-Cleanup-uuid-strings.patch

I am waiting for Joel to comment. If he approves, then you can use the
same #define in your ioctl.
