From: Eric Ren <zren@suse.com>
Date: Fri, 19 Feb 2016 11:01:24 +0800
Subject: [Ocfs2-devel] ocfs2-test for v4.3 done
In-Reply-To: <56C3D7DC.2030403@oracle.com>
References: <56776B6B.2010208@oracle.com> <20151221135038.GA3194@laptop.ha>
	<5678B6AC.1080005@oracle.com> <20160216095411.GA8125@laptop.ha>
	<56C3D7DC.2030403@oracle.com>
Message-ID: <20160219030124.GA4861@laptop.ha>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,

On Wed, Feb 17, 2016 at 10:15:56AM +0800, Junxiao Bi wrote: 
> Hi Eric,
> 
> I remember i described it before, please search it on ocfs2-devel. For
> ocfs2 env setup, please refer to README in ocfs2-test.

Yes, you did. Actually, it's the  quoted paragraph below;-)
Thanks, but more things what I really want to learn about are, such as:
1. git hook/auto control scripts, if it's OK to share;
2. pain point and solution, for example, a latest tagged release kernel may
   not compile successfully by `make defconfig` or `cp /boot/config-`uname -r``;
   Or cannot boot up even if we've built kernel RPM and installed it.

   Did you have this problem? Any suggestion;-) What I can think of is to try opensuse
   tumbleweed distribution(a rolling release).

> 
> On 02/16/2016 05:54 PM, Eric Ren wrote:
> > Hi Junxiao,
> > 
> >> Four vm are used, one for git server, and the other three to build
> >> kernel and run ocfs2 test. Tag a branch and push it to the git server,
> >> the test will be started. The test cases to run can be set in tag message.
> > 
> > Recently, I get free days and also want to setup automatic testing env for ocfs2.
> > I'll use pcmk as cluster stack while you probably use o2cb. I think we can complement
> > each other.  May I bother you to describe the work flow more specifically, or share
> > experiences and references? That way it would save my life;-)
> > 
Thanks!
Eric
