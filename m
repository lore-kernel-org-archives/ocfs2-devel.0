Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49A48C77B73
	for <ocfs2-devel@archiver.kernel.org>; Wed, 19 Apr 2023 21:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=O6GJDrOZNmKI5PWAhnnEtTdxvYGN/lffdVJytu+68fw=;
 b=t682ExTpr73m0Tfynlnd3ZcvJ6F8ywMhXr822vBGQCgJm/WhXoWOz8/bDoql2Mb/FI5WXc9RZFDj
   LtgDzBBaPt2dBedD1yd0/E9sqw8c2MFMBSF4rEHjhCY7wm4wPFjrCBggnSIkoB7/LLx25NgzJ4fq
   EhFcvvFC7GSyGxW1GtO/Wmzb7OF3Sw5reC7t7wXGdWfMTzSOgXhziO0XD0Yg4+tjQfHyJ6/Tpv4s
   A1jpN1xvHS3V6j7iX6m2mh+2Xn0Erc/qy05ZDhSUTKKB0qxPqqFN0vcyP4JJlW02x274Ku5QVoRJ
   UjgAvQkaQsEs8kv/+QtTPdAadfXTXBEBMjU22Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=O6GJDrOZNmKI5PWAhnnEtTdxvYGN/lffdVJytu+68fw=;
 b=ruFFPM7Qy5oNGZ8IwK1UlvqP+i0w5NEI9U4qqD7qSTLAOkv69zkf2HHB2EmqTpriOE92hYZda0e3
   B1McIoEbCDDe8QMdYYoRGcotMgSf0JwlU6iKdvt0tXsCWHILw5F3r3mYJF4E+ns48Z2esE2zNTD1
   fs9NiZhHHr1Ivfn/Te9VQyHMRkOxC4H4L9zX7YunbFOIn62qRrhaj8sQVDvNtOJqLT5T7kHrlxlB
   HO0bDtE+vWqF6YzkFHpc6CStlf0F6gUvV4jOS3rt3hbEty+P0vJoT/5jtTv8aWK6qIRg0LDShkhY
   6MF7YJCUH99JpfWQnw9kjm0Chk5rzm884qk55Q==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230404 64bit (built Apr  4
 2023))
 with ESMTPS id <0RTD00D22SP4VO10@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 19 Apr 2023 21:22:16 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1681939320; bh=8FeQtFAQmPMVFM6tlsPfxwIQGqlujFEHWXaf5ZMyDsM=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=O6ocRganDUAI/lV4ZCyRbchU+HXxtFyVbREH3btuT0gjfzXgwtyv7D43AyPRMzXyA
 EQ6Pd2R4k+DRhAtQvNH3oWtdQ82oY/hINPkXCHmrPVdxYHYJVGSb2YkAasQvskU9w6
 mcADFIq4WPfezFJM+igySqjMcS2Us4tmG7ZULkt8=
Date: Wed, 19 Apr 2023 14:21:59 -0700
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20230419142159.fd5ca2e91658fe304e317a72@linux-foundation.org>
In-reply-to: <d1e719ea-95bf-bb96-62db-e550cefe0a80@linux.alibaba.com>
References: <20230417205631.1956027-1-arnd@kernel.org>
 <20230418-fortgehen-inkubationszeit-5d3db3f0c2b1@brauner>
 <7555eaf9-b195-5189-3928-c7292e4a0ba5@linux.alibaba.com>
 <20230418-vielmehr-nominieren-7f2adb0f6703@brauner>
 <d1e719ea-95bf-bb96-62db-e550cefe0a80@linux.alibaba.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10685
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 mlxscore=0 malwarescore=0 impostorscore=0 spamscore=0 clxscore=213
 lowpriorityscore=0 suspectscore=0 mlxlogscore=895 bulkscore=0
 priorityscore=120 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304190184
Cc: Arnd Bergmann <arnd@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: reduce ioctl stack usage
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
From: Andrew Morton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Andrew Morton <akpm@linux-foundation.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: MjbvQllqz1tcrlrjcWlNDWBcM-UwYRw7
X-Proofpoint-ORIG-GUID: MjbvQllqz1tcrlrjcWlNDWBcM-UwYRw7
Reporting-Meta:
 AAEMmoblMiCe0gU2BaJ1glE2Hp8MKurZ1PZ/C+jzdEJTrY0ADYLq4mdJf7rsTlo3
 AfGmoBxgC/OEKOV99Dt1Y4WPesgLbUWL2f8OA1jrZucZzeEprJPJlD5nK8kCMer/
 pXCuVAkc4TLaH8bYmI1UBZaOPVG9q/GiqFG06QGLXukum4Sp+sE+xqwAnxCU6RiS
 Tv9KN/91BMngL9/akDA9hEVSeK+3tngiN3aWUtH+p3RmTqiHwKAsz+TQBs169BlX
 +Or9Yt++Gb7sA9Z9nVrk55sJ8CM6Zwe48jRtCA8hEJ+Yk1C7sBL/tlh9XmJDnJG3
 VtzXJOo5Vs4V79RiuUdCDTvGvgvIEi0sSW4IbqewXSc3hfReTacpMNSvkL5YtMgg
 5b8fpakh51XmX7Op9ceFsoo3hEtfhu5v3/v7gmafFl8MOcmwbsZWdUi73uQXT0vY
 M11gIWPiWMWwlk/BWL2ze1470dm0GSu5SNp7b5d1xgZAWsOQM/Qei8XJN42Pa2H/
 U2S24wCbbIMvJEI40tvfDu7i/wh49RW3MEPtZWJxyU8g

On Wed, 19 Apr 2023 10:00:15 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> 
> 
> On 4/18/23 8:56 PM, Christian Brauner wrote:
> > On Tue, Apr 18, 2023 at 05:37:06PM +0800, Joseph Qi wrote:
> >> Andrew picked ocfs2 patches into -mm tree before.
> > Yup and that's fine obviously, but this belongs to fs/ and we're aiming
> > to take fs/ stuff through the dedicated fs trees going forward.
> 
> Either is fine for me.
> Hi Andrew, what's your opinion?

I've been wrangling ocfs2 for over a decade and this is the first I've
heard of this proposal.

Who is "we", above?  What was their reasoning?

Who will be responsible for ocfs2 patches?  What will be their workflow
and review and test processes?

Overall, what benefit does this proposal offer the ocfs2 project?

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
