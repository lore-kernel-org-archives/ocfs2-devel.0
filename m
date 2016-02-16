From: Eric Ren <zren@suse.com>
Date: Tue, 16 Feb 2016 17:54:11 +0800
Subject: [Ocfs2-devel] ocfs2-test for v4.3 done
In-Reply-To: <5678B6AC.1080005@oracle.com>
References: <56776B6B.2010208@oracle.com> <20151221135038.GA3194@laptop.ha>
	<5678B6AC.1080005@oracle.com>
Message-ID: <20160216095411.GA8125@laptop.ha>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,

> >> I have setup a test env to build and auto do ocfs2 test. With it, Ocfs2
> >> for mainline and linux-next will be test regularly, the test status and
> >> bugs will be reported to ocfs2-devel. Feel free to take any bug if you
> >> are interested, it will be a good start point with ocfs2. Hope this can
> >> catch regression bugs earlier before merged by mainline.
> > I'm very interested in how your testing env works, could you briefly introduce
> > it?
> Four vm are used, one for git server, and the other three to build
> kernel and run ocfs2 test. Tag a branch and push it to the git server,
> the test will be started. The test cases to run can be set in tag message.

Recently, I get free days and also want to setup automatic testing env for ocfs2.
I'll use pcmk as cluster stack while you probably use o2cb. I think we can complement
each other.  May I bother you to describe the work flow more specifically, or share
experiences and references? That way it would save my life;-)

Thanks!
Eric
