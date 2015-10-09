From: Eric Ren <zren@suse.com>
Date: Fri, 9 Oct 2015 13:12:07 +0800
Subject: [Ocfs2-devel] OCFS2 test project current status ANNOUNCEMENT
Message-ID: <20151009051207.GA11859@laptop.ha>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

Now, we have already collected 55 patches into Mark's github repo[1]
since Mar 16, 2012.
[1] https://github.com/markfasheh/ocfs2-test

Thanks a lot for their contributors:
    Junxiao Bi: 23
    Jeff Liu: 11
    Tiger Yang: 12
    Goldwynr: 5
    Eric Ren: 3
    Gang He: 1

This patches below are dropped, need improved, or conflicted with
previous ones:

[PATCH 09/10] Trigger udev rescan to get volume label that mkfs made remotely.   -- relate to blkid.conf, needs improved
[PATCH 42/59] mmap-test: fix segment fault  -- needs improved
[PATCH 48/59] ocfs2-test: fix build error   -- conflicted, dropped
[PATCH 45/59] flock-test: disable posix lock test   -- needs improved
[PATCH 53/59] discontig: fix remote mount   -- conflicted, dropped
[PATCH 32/59] xattr-test: fix single test failed    -- conflicted, dropped
[PATCH 17/59] Splice: Fix conflict definition of splice(2) for splice tests.    -- conflicted, dropped
[PATCH 13/59] aio-stress: fix aio-stress Makefile to link pthread explicitly.   -- conflicted, dropped

There might be some incorrectness in my conclusion. For details, please
refer to ocfs2-test-devel mailist!

Test project is very important to ensure the quality of ocfs2. Welcome
more contributions from you! Let's make it better;-)

Thanks,
Eric
