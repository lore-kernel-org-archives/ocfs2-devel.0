Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C07D3C54EBD
	for <ocfs2-devel@archiver.kernel.org>; Fri, 13 Jan 2023 10:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QgD5J6ll6FKM1SEE93kM9cffc1ISoEYuHOUJcGXgvWg=;
 b=AiO3hjOBorfYzarnmeRit7hcH3Dtvu1UHO5qalDBg5o2jrwpZgSp6uegQxpIDqmAXf7PNKuUY/l+
   e+13hP8LyAPH5RUuxQ427zw6ZW43TtloIbmp1FH/mjvts68a1ErbSkdmvTCXeMpFYk4b3FddY7FP
   qhvmLiP7cGAO4xPDT9j+Lq2kMcfSLUkeSdUT+ZbhRSlhD+tYPZ2AXphqfSQ7x3g3NdTf0a/ftoE5
   Bb0yQ7W+WOogdFH1mYI7fwqr/mFSAeVp6TQYOkal67J/+Ul5ZTjxFkRLh74248zjhUKvlSzE0aCg
   9gvUyqqr2ZMkWeBqzrzjzWjcf8KGHwqVS8Labg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QgD5J6ll6FKM1SEE93kM9cffc1ISoEYuHOUJcGXgvWg=;
 b=gFugLQolDcpyGQPTUIyFOIAYtgDu6XGcTlVgWCBzDN4NdCs2XURbj91tKmf0x22Mhhmkk7Jl4+pu
   Q8DuxsFMLQ9C0CYGXAkomOzc6LXJIMB+bW+HajzJPZQoZQfCM+aYSbe14RSQzJny08SOAEwL7d7A
   DVtSt9Ug24fmw4GrEAN+J+7YSSJ0qa+uhhCfgAaUiKycwh5rgyQCCXeGFR4AAdK/eSEYTC2bnTPE
   0+u12QLLww3fBtKvFqjoUemHfkwVwqV4C7atZIOKEoxLIsHDIYdzQCPsiRatql2deErLBYqa4TX9
   W/qfYMw7SpNsLPYUKPGS562u32/jOGZRlJGEtg==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROF002K16SAE2A0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 13 Jan 2023 10:36:10 +0000 (GMT)
Message-id: <7e8af24bc175b425777c1e689c26562dc743bfd5.camel@huaweicloud.com>
To: Paul Moore <paul@paul-moore.com>
Date: Fri, 13 Jan 2023 11:35:13 +0100
In-reply-to:
 <CAHC9VhS0SnEb46-FBpn2JpC2dJ7OnkeJ2EtLBvVvkOLdfFmcbg@mail.gmail.com>
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <CAHC9VhS0SnEb46-FBpn2JpC2dJ7OnkeJ2EtLBvVvkOLdfFmcbg@mail.gmail.com>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-version: 1.0
X-Source-IP: 14.137.139.154
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10588
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
 mlxscore=0 clxscore=206 impostorscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=819
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301130073
Cc: nicolas.bouchinet@clip-os.org, linux-kernel@vger.kernel.org,
 keescook@chromium.org, selinux@vger.kernel.org, dmitry.kasatkin@gmail.com,
 Roberto Sassu <roberto.sassu@huawei.com>, jmorris@namei.org,
 zohar@linux.ibm.com, reiserfs-devel@vger.kernel.org,
 linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
 eparis@parisplace.org, linux-integrity@vger.kernel.org,
 stephen.smalley.work@gmail.com, ocfs2-devel@oss.oracle.com, serge@hallyn.com
Subject: Re: [Ocfs2-devel] [PATCH v7 0/6] evm: Do HMAC of multiple per LSM
 xattrs for new inodes
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Roberto Sassu via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Roberto Sassu <roberto.sassu@huaweicloud.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-CM-TRANSID: LxC2BwC3PAjkM8Fj60SSAA--.55533S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CFW8WF18ZFW5ury8Ar1UWrg_yoW8CFWUpa
 9xt3Wagr4kWFyUKr43A3yjk3yUGr4fGF13X34fK34jyrnxuFn2gF1xGayrua4DJrn3u3sY
 vFW3W3sru3Z5u3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
 AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
 x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
 0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
 64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
 8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
 2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
 xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
 c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UZ18PUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAQBF1jj4eOnQAAsw
X-CFilter-Loop: Reflected
X-ServerName: frasgout12.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: 8T495fYwnT9k7tlKSylIrWyTlIxjqckC
X-Proofpoint-ORIG-GUID: 8T495fYwnT9k7tlKSylIrWyTlIxjqckC
Reporting-Meta:
 AAETJAkoSoE1+EeWQ5SNMiUZLmhDDLoK0cevIMsoi0Ov2I9KQlU5owLAE1aPkCY3
 O9QIVKIcDAgsP4aHA5MmCTpBANeUveTcrgByuAfnRevBPVJ3qP3nGcjGpbORAOFg
 eArxcwF1Q5xupHBqSGfwGnAWvJLQlK9eN8Me+LhmalNrp1/iqM1aXE9XlLVrxCgp
 0fTSfupS97VgCNOrGNFiO2B3YSyygdgiU/T2W8M2nNz/O4A53xh0vMVcZB9hY30o
 j0Scz6enl5Pe8BPuiHy0ILmYMw7FDn0h9k1CqDhuhaNRu4Pl5/cUNkZy2DM8GxpZ
 c9+kFLiqZN+nEv8teJ6D/zS7Rd4/gmxHod+71WgV7Uczr/ZFK3cX6pPdpgWF77z8
 V8Xg7eXWxdMra5NENy9s4SIKv3eP4rpOnvfRbbVqvzDoaWcFnPTZxXzPrrpYl+iq
 5kjK2fAvY8Ixa/Yg/lDjysHd1R4w29dxdUjlbgT+aufpSLy9633I+kIY56ETJWCj
 2lD2yPdZQZoHdpJA/SMf0tr7aDmjQmlux37x3auzc/Mm

On Thu, 2023-01-12 at 12:15 -0500, Paul Moore wrote:
> On Thu, Dec 1, 2022 at 5:42 AM Roberto Sassu
> <roberto.sassu@huaweicloud.com> wrote:
> > From: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > One of the major goals of LSM stacking is to run multiple LSMs side by side
> > without interfering with each other. The ultimate decision will depend on
> > individual LSM decision.
> > 
> > Several changes need to be made to the LSM infrastructure to be able to
> > support that. This patch set tackles one of them: gives to each LSM the
> > ability to specify one or multiple xattrs to be set at inode creation
> > time and, at the same time, gives to EVM the ability to access all those
> > xattrs and calculate the HMAC on them.
> 
> ...
> 
> > The patch set has been tested with both the SElinux and Smack test suites.
> > Below, there is the summary of the test results:
> > 
> > SELinux Test Suite result (without patches):
> > Files=73, Tests=1346, 225 wallclock secs ( 0.43 usr  0.23 sys +  6.11 cusr 58.70 csys = 65.47 CPU)
> > Result: FAIL
> > Failed 4/73 test programs. 13/1346 subtests failed.
> > 
> > SELinux Test Suite result (with patches):
> > Files=73, Tests=1346, 225 wallclock secs ( 0.44 usr  0.22 sys +  6.15 cusr 59.94 csys = 66.75 CPU)
> > Result: FAIL
> > Failed 4/73 test programs. 13/1346 subtests failed.
> 
> Can you provide some more information on which of the
> selinux-testsuite tests failed?  That shouldn't be happening and I'm a
> little concerned that these test failures, even if unrelated to your
> work here, could be masking failures which are related.

Uhm, my virtual machine has been used for many tests and was not clean.
This time, I installed a fresh Fedora 37 and compiled the kernel with
the same configuration as the shipped kernel.

Everything works now:

All tests successful.
Files=74, Tests=1363, 210 wallclock secs ( 0.42 usr  0.11 sys +  6.66
cusr 22.33 csys = 29.52 CPU)
Result: PASS

Roberto


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
