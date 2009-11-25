From: Coly Li <coly.li@suse.de>
Date: Wed, 25 Nov 2009 15:43:13 +0800
Subject: [Ocfs2-devel] what is global bitmap, block group, suballocator, etc
Message-ID: <4B0CE011.3030403@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi list,

There are some ocfs2 terminologies that I don't understand very well. After checking the ocfs2 wiki and kernel/tools
code, I am still not sure whether I understand them correctly.

- Global bitmap
  What's the usage of global bitmap? Which kind of resource allocation will set global bitmap?

- Cluster group
  It seems cluster group is similar to block group of ext3/4. Does each node of the cluster has its own data/metadata
bitmap inode in every cluster group ?

- Block group
  From Tiger's slide, I don't find block group. But from fs/ocfs2 code, I see block group. Is it same to cluster group ?

- Suballocator & Suballocator slot
  I don't find related document explains what is suballocator and how it works. I am checking the code now, but not
clear to me yet.

I know all the answers are in the code, I spent some time on code reading already, if there is some hints, I can do it
faster :-)

Thanks in advance.
-- 
Coly Li
SuSE Labs
