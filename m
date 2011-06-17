From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Fri, 17 Jun 2011 10:55:12 -0500
Subject: [Ocfs2-devel] How can ecc be corrected?
Message-ID: <BANLkTi=SHS1W7umXmY9egUrGK0SWeOjQ7w@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

I am not able to understand the use of metaecc or the ECC in the
metadata. All the metadata contain the ecc to check if the data
written to the block is sane, but what happens in case the ecc does
not match? All it does is fail in case it does not match. There does
not seem a way to correct it.

fsck simply fails in ocfs2_read_inode, (or in some cases such as
superblock inode (2) does not even check) if the ecc does not match.
What is the best way to correct ecc errors? I understand that an
incorrect ECC means the data might be corrupt, but what if we want to
recover? or is it not meant to be corrected at all?

Regards,

-- 
Goldwyn
