Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B281FC433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 10 Mar 2022 13:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NUe51oA9+nsKxiawG6/cALGDt/Tge4Fc1MfE61LVKCE=;
 b=W6BcFOysmliCWHuSX5Lnsp3VUC4/ywlbTnpEObBx3Pfpf9e5IhUcvBHIjHOwrR5rroN/1slRsNhE
   /i3MQydpC9nVGBDuKifyQkp5+dy2JAHcugHIKlPIR7H9jHr2ymAHB1VhyvjGhVfAEqpMALhtA+jy
   v1IOlOG5VtJg1HRR+HH80gmx2Qb94kI1DssNqlF744NUicb/e0mdYEtt0ScaAljrSG/JFoOxzNGP
   9W5CzZKUkpIh2aPwz3Wfq1QGdVrThbDpHiArKVNGogucO1J+OfHH+MTXSUhJ6JQ1yRNx8oOaya0p
   833r4XPU3nwakeTJUu37MklSZheLEzQAAYqg7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NUe51oA9+nsKxiawG6/cALGDt/Tge4Fc1MfE61LVKCE=;
 b=WhvC1Je84xq79TEJU8nhSn9fpFJPycsKcxeQEGH5xPV6lQA0zNlZA/+fPlbsMO5mueSObdRY1IOQ
   /xRFtzmNxvU3MnfBP5p7AB+I+2Jr00MNOmo6wFblnlXMHlA+RVlQAMxhBccVy8QdqDHs1PMbTaxl
   ay4qARrMsCHQmLbQ166PofW4m7tPsY2aindqAMou7avBv2jXw6m7Hv1cXGpOexNH9rlIzszPhB+q
   VxUFDrXN3W0iXRphOe7ta+c0sqvbN1WT7l6wF6wrjF7zX1mY/dEr04hX99tSJGlK7B7gjsh5sqis
   pKQQKkrxIWuY2JxZUatx1TUbL8kZ9Rlnc/1qcg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R8J00N6K7A5XD90@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 10 Mar 2022 13:39:41 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date :
 from : to : cc : subject : message-id : references : content-type :
 in-reply-to : mime-version; s=corp-2021-07-09;
 bh=r2Yj7B17/HcvuSi4RES9kwNBsaNmZIzyyL2RvE/u4og=;
 b=ifYoGi8vn+v63+ECCEjQELLPnYnTpqFdlb/Y4y987motTG2NdQ+Fc8fTm6mDIDsQXlB2
 QRPBpS468EEAQ8FE91zWG78sznntPXyRYMDxFEhJlxN4vJGWRzELTWom6nnwg3ZhezAG
 z/RZs6mMrJk69xeq/fHinq8nVQBS0ZM9Uy7Mbo9VQOb3T+2LWbC6hC3Zmfu+/nectwCg
 /gq/mvgs93a4YHRVIx0Xqgcak6occA+gQMqOLxjzTqT1EyRx6E2OArOJ7sTUdpxp85ny
 +J9ZC7SdKe+zSgRwOjvtJe/WZFNrS3XuiLwTZnP5e9oPHOBZLMYOv/+kmW9HRYr/tEhe 2g==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=dan.carpenter@oracle.com; dkim=pass
 header.s=selector2-oracle-onmicrosoft-com header.d=oracle.onmicrosoft.com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WIpJNUN2Yd+6OMUiYLYUOEIUX5qgeUedrunv/M9vE5EcYMgN86GxCFegy058QbZIY7fDlIL/+7k+JqRgzOVrNnyRR4cMMJoaZAMzI1II+57TYWyitFX4XO31gbPQ8j9W/etJTZvfpDOcoGA+eurfwFpJvY/dKVOBhQ3m6k7Rm8nvRybyFlt0Q0PXu7MD+wKaI7LsSd8zgS4999p5AOUnKqUG1+Y/RaRK5oSejJwJk5pGnFM24cP9laESne2LN7rr5tukLj0KHWE+S+NKi9pn1PLTPMe6BfuPomOTYVbqjIsXOK+I6OwOhtKbmqyj9YJ46UrJoXgWRTeOzj4xHcPkMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2Yj7B17/HcvuSi4RES9kwNBsaNmZIzyyL2RvE/u4og=;
 b=mhCohhEa2S/bCosPtlvToowyeQN29+wHRn/QIlMEAtmYhqd5fGwucToIXpoiz34QenR0Qvp/7wl5S5A1hsA7W7eGRekBfYrBeT7YGqJ3xz279G+dp1f94XhuPTdEOg3frlH16X1/OrYVuTQC9aAzXZSU2fND4SzOaY95rHGga/18sTchDchzyjN577D5TtHvODET1EECc5AcX7/T0IoYl0KCZeX981ALV8R1RupYhHgN3d9pdtnqOJXFVfFXPsY4jK0UbhRHPkWu3u71m3QPfr+19iZboOb+nhDg3wlLn9+cxxdwxnM4QC94PnbD2N48+SMGwKFf6772MUVZkCR5yQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2Yj7B17/HcvuSi4RES9kwNBsaNmZIzyyL2RvE/u4og=;
 b=YP5ziLwbh6n3U3OwxziFcnpMzIq/ivX+McyjfQg7DTf8cn1jp4nSm2D2/5XU3C0tOMU3g3ytPPsYYxz2Y4O09LnWbk81oEQ93PxLsqIUQTe185kC6u3QArsDUWyfKzbl2lAbypsQU0PGI3mQRpq5nRL7ilavBZ8YIz3iJwlHwP8=
Date: Thu, 10 Mar 2022 16:39:18 +0300
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20220310133918.GH3315@kadam>
References: <20220307145138.GA22641@kili>
 <82b26a4a-2351-f2b3-dd7c-265308e6b384@gmail.com> <20220309145717.GX3315@kadam>
 <5a5933bb-3078-2cfa-9403-a6b497199449@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <5a5933bb-3078-2cfa-9403-a6b497199449@linux.alibaba.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:MWHPR1001MB2365.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 13:39:30.2985 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281
 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 spamscore=0 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203100073
Cc: Jakob Koschel <jakobkoschel@gmail.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [bug report] ocfs2/dlm: Fix race in adding/removing
 lockres' to/from the tracking list
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
From: Dan Carpenter via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Dan Carpenter <dan.carpenter@oracle.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: MR2P264CA0121.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:30::13) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96323f42-5ff9-4f1d-6675-08da029b6714
X-MS-TrafficTypeDiagnostic: BN6PR10MB1508:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 nR+2WsjpVMF7xXK/ir9wrgJw07Tp4l9H3nOK7eXlrbKmS7nSWf6/CHEUYMia8pehRiG3PS8IG0PMFaiaGI1x4nXZPkgTSXc3K3Jq1QoT6nduZAwsNNGORCVUtbc8T/DXbP4iS5jZExBFe0mxiwmRM1nw/NydGtpDjhe9V+yYBIM0O52L4lTMrloqmtB2UYwpyb2COZPCKb8wa+JrHTy3FNKLqgNp2LGzSaJHKNqBG1g7FS3nfXiQU54G8UYqjr7PTYYOZHZRsWG4j41EmvEhV3/XAEIxOzbYjER/PjkNh+zIepIPj2dQzqg92wealLwDoH3sjpMQF/8QjneqmBa/Sfk/8M5ug+qLSboG+wGTX/bqeKU3o6EcUK/a5NM2U/JGzEDmhIJAsPKiJwcEsAvt5uw5WH/tQHVXUvsNbB0tXBT8CxWAJgGNOkdEo1T569JHkMazVDT0vfBh6vHmLmJSwbJNC01BTSQWUoejD7ZqoTaLg5XgzRtUFehcQ2qqc3v2gVOA2Ks0MjYGAcxYJfBjEY5/V2lkKYnF2x+YgMd5i6afRobmCMbJo2w5EHS6mN+gbcgY4al9Fx+M0U9iiNaK5dmGh3BgOmRYTw6En3JCqXw=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 96323f42-5ff9-4f1d-6675-08da029b6714
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 wRjfYJcjdYTuswj4lVY4q0+uvvEglxerxlmTTwJ4669qz6SZmQeBjfkXlgZ+hiGZCJJVaGfsqYErCWWGRWtg9mn6SnjvjrAKzTEd19k9Ohk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1508
X-MS-Exchange-CrossPremises-AuthSource:
 MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission:
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: Dan Carpenter <dan.carpenter@oracle.com>
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 62.8.65.185
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating; SFV:SKI;
 SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: BN6PR10MB1508.namprd10.prod.outlook.com
X-Proofpoint-ORIG-GUID: ah0hLfZd5jbcm_7YlSyLXtMppZIXKBsp
X-Proofpoint-GUID: ah0hLfZd5jbcm_7YlSyLXtMppZIXKBsp
Reporting-Meta:
 AAGcTKyNyeR13zdoDKXRoRo5u6iHtUoprVV+7CNW040vf8YUt89tEuiL8EB7MOzV
 U5mvTS0bYRNtueCYX0NGvNAdFy0yL8keOLixSaTKxFqkhmiy2YWOgHFIAdEhmkjk
 Ed/jEjfhFXe8EObCTw3znWVOYyYKWj/RM+Oct0zctk4tbbaiVK3LmY6g7fHrzAzt
 Qt7hBEtD1Jm5Y/iOdHLqNnQ1MxBhA/023OSKujWIufTC6RgeaUKyxPHNWoD95iqx
 rAgMcj6QCL802pMAYfdgQRV9G9ynrzKIkrKbM3l/8BDAQllDAYpPpQ6iLFLdJwbA
 xe2hxrBcJR9aWqoJu1NGsV+w89pVHbKpACcVHBAudJiSQjb92//6vTcKZOrxuI8v
 3R486d8eCyy146hEPdHWqpPlhl0J5PIYjfvx1+KKD4J1uvdAS11XpDH7y+4w+HXD
 bhE6mKt1YlQs1/3xxbUAa/WQYCILYWkC/2NBwicw1xq9uTE+d07nmcqmK1tlKYzR
 4o5c94AzSRZS2yGl1LHlK2hp3nv1uS3zRyJGL2gdMYuRNQ==

On Thu, Mar 10, 2022 at 11:13:05AM +0800, Joseph Qi wrote:
> >>>     557         }
> >>>     558 
> >>>     559         list_for_each_entry(res, track_list, tracking) {
> >>>     560                 if (&res->tracking == &dlm->tracking_list)
> >>>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >>> This should never be possible.  How is it possible?  If
> >>> &dlm->tracking_list is the list head the it's not possible without
> >>> memory corruption.  If &oldres->tracking is the list head then I do not
> >>> see how it is possible without memory corruption.  We can't mix different
> >>> types of list entries on the same list head?>
> >> In case of oldres, and the iterator points to dlm_ctxt.
> >> In this case, the lockres is not a valid one.
> > 
> > That doesn't make sense.  :/  This condition is doing pointer math.
> > The offset of ->tracking is 136 bytes and ->tracking list is 88 bytes
> > into the dlm struct.
> > 
> Now track_list is oldres->tracking, which is already linked to
> dlm->tracking_list?

Are you saying or are you guessing?  :P

It's not impossible to set this condition up so that it's true.  But
it's bug if someone does that.

I really think that condition can be deleted.  If you look at the commit
which added it b0d4f817ba5d ("ocfs2/dlm: Fix race in adding/removing
lockres' to/from the tracking list") the it's easy to imagine that it
was a copy and pasted pasted by mistake.

Or another possibility is that it was debug code that was committed
accidentally.  After all if you remove the locking a delete the last
entry at the right time then it would be easy enough for the condition
to be true.  Hopefully, these days the locking prevents that condition
from being possible.

regards,
dan carpenter

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
