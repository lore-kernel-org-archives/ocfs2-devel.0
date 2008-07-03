From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Wed, 02 Jul 2008 17:49:54 -0700
Subject: [Ocfs2-devel] Add --force option in tunefs
In-Reply-To: <20080702194431.GH29916@mail.oracle.com>
References: <20080702094655.GA6088@baloo.nue.novell.com>
	<20080702194431.GH29916@mail.oracle.com>
Message-ID: <486C2232.606@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Well, we need to have a --force override if only to allow users
cloning ocfs2 volumes an easy way to change the uuid.

Goldwyn,
What is your justification for needing this feature? As in,
allowing force override to change mount type from clustered to local.
Is this a specific user requirement?

Our fear is that this override will allow some script author to
hard code it leading to corruption. As in, click here to change the
mount type. I mean, we already have a force override in mkfs, but
format is something users understand wipes the data. I am not sure
users will immediately understand that changing the mount type will
corrupt the fs if it is mounted on another node.

Sunil

Joel Becker wrote:
> On Wed, Jul 02, 2008 at 03:18:04PM +0530, Goldwyn Rodrigues wrote:
>
> 	Hey, there.  Tools changes belong on
> ocfs2-tools-devel at oss.oracle.com, so I've copied that mailing list.
>
>   
>> This patch enable --force option in tunefs.ocfs2
>> Like mkfs, the --force option ignores cluster initialization 
>> and locking.
>>     
>
> 	Thanks for the patch, but we decided long ago that we didn't
> want tunefs run without the cluster.  That's why there is no force
> option.  It's intentional.
>
> Joel
>
>   
