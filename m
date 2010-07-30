From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 29 Jul 2010 19:12:24 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Flush drive's caches on
	fdatasync
In-Reply-To: <4C5233CB.5000600@oracle.com>
References: <1280404846-9388-1-git-send-email-jack@suse.cz>
	<4C5233CB.5000600@oracle.com>
Message-ID: <4C523508.80802@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 07/29/2010 07:07 PM, Tao Ma wrote:
> Hi Jan,
>
> On 07/29/2010 08:00 PM, Jan Kara wrote:
>> We have to issue a cache flush during fdatasync even if inode doesn't 
>> have
>> I_DIRTY_DATASYNC set because we still have to get written *data* to 
>> disk to
>> observe fdatasync() guarantees.
> I am fine with the patch from the code's perspective.
>
> But I just noticed the discussion in fsdevel with the subject "relaxed 
> barrier semantics", so with barrier there will be a massive slowdowns 
> according to Christoph. And as ocfs2 is mainly used with some SAN, I 
> guess in most cases the storage will have a battery backed cache, so 
> we may not need this?
>
> Sunil, Joel and Mark, Did you have any user data that most of the 
> ocfs2 system is used on or can we start a survey in ocfs2-users?

A SAN with a battery backed cache is a safe assumption. That's
why we don't enable barrier by default.
