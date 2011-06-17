From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 17 Jun 2011 09:53:40 -0700
Subject: [Ocfs2-devel] How can ecc be corrected?
In-Reply-To: <BANLkTi=SHS1W7umXmY9egUrGK0SWeOjQ7w@mail.gmail.com>
References: <BANLkTi=SHS1W7umXmY9egUrGK0SWeOjQ7w@mail.gmail.com>
Message-ID: <4DFB8694.6080303@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/17/2011 08:55 AM, Goldwyn Rodrigues wrote:
> I am not able to understand the use of metaecc or the ECC in the
> metadata. All the metadata contain the ecc to check if the data
> written to the block is sane, but what happens in case the ecc does
> not match? All it does is fail in case it does not match. There does
> not seem a way to correct it.
>
> fsck simply fails in ocfs2_read_inode, (or in some cases such as
> superblock inode (2) does not even check) if the ecc does not match.
> What is the best way to correct ecc errors? I understand that an
> incorrect ECC means the data might be corrupt, but what if we want to
> recover? or is it not meant to be corrected at all?

I think originally our thought was that bad checksum means bad block. But
we are wiser now. As in, while that works in the fs, we could to do better
job in the tools. And that's the reason it is not yet enabled by default.

If you have ideas, do share.
