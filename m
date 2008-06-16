From: Tiger Yang <tiger.yang@oracle.com>
Date: Mon, 16 Jun 2008 18:22:46 +0800
Subject: [Ocfs2-devel] [PATCH 7/8] ocfs2: Add extended attributes
 support. v1
In-Reply-To: <20080613032230.GW28100@wotan.suse.de>
References: <484792D1.3080802@oracle.com>
	<1212650694-9603-1-git-send-email-tiger.yang@oracle.com>
	<20080613032230.GW28100@wotan.suse.de>
Message-ID: <48563EF6.2090203@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Mark,

Thanks for review my patch and comments.

Mark Fasheh wrote:
> You'll have to go through the code and determine where we need to use the
> new functions. Please do this as a seperate patch by the way - it's a tricky
> enough operation that I will refuse to read the change if it's intermingled
> with other stuff.
>   
This is a serious problem. The patch attached fix this problem.
My patch could handle EAs in inode block or in external block at the 
same times. That is little different between design doc.
If we find free space inline, we will set EAs in it firstly, otherwise 
we will set EAs in external block. This resolution just like ext3 does.
So i_xattr_loc could only be used for contain the number of external block.

> What hash function is this? Where did you get it from? How good is it for
>   
> use with EA names? How good is it for other uses? Answers to all those
> questions belong here in e-mail, as well as a nice big comment at the top of
> this function.
>
>
> Also, there's this item in the design doc:
>  * need a random seed in super block which is never printed on console
>
> We want to combine the random seed with the hashing process somehow so that
> the results for a given name are not globally predictable for all Ocfs2 file
> systems.
>   
I got this hash function form  ext3_xattr_hash_entry().  In design doc, 
"The hash value is calculated using the full (prefix.suffix) name of the 
xattr to avoid hash collisions when the same suffix is used in multiple 
attribute namespaces. It it used to identify when a name is not going to 
match before doing a string comparison to verify that the name is a 
match.", so I got the hash value form EA's prefix and EA's name. 
Actually I didn't compare hash value and sort EAs when EAs in inode for 
in external block, Because only few EAs could be stored in inode or 
external block. Tao use this hash value for large number EAs in bucket.  
Next I will use that random seed for hash value.

I will correct other problems you commented.

Best regards,
tiger
-------------- next part --------------
A non-text attachment was scrubbed...
Name: Reserve-space-in-inode-block-for-extented-attribute.patch
Type: text/x-patch
Size: 5848 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080616/14db24eb/attachment.bin 
