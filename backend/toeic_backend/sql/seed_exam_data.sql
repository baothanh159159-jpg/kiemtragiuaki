USE ToeicExamDb;
GO
SET NOCOUNT ON;
BEGIN TRANSACTION;
BEGIN TRY
    DECLARE @ExamId INT;
    INSERT INTO dbo.Exams (Title, DurationMinutes, TotalQuestions, CreatedAt)
    VALUES (N'TOEIC Reading Actual Test 01', 75, 100, GETDATE());
    SET @ExamId = SCOPE_IDENTITY();
  
      DECLARE @PartId_5 INT;
      INSERT INTO dbo.ExamParts (ExamId, PartNumber, Title, Instructions)
      VALUES (@ExamId, 5, N'Part 5', N'Directions: A word or phrase is missing in each of the sentences below. Four answer choices are given below each sentence. Select the best answer to complete the sentence. Then mark the letter (A), (B), (C), or (D) on your answer sheet.');
      SET @PartId_5 = SCOPE_IDENTITY();
    
        DECLARE @QId_101 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 101, N'Ms. Durkin asked for volunteers to help -------- with the employee fitness program.', N'Đại từ tân ngữ ''her'' làm tân ngữ cho động từ help.', 101);
        SET @QId_101 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_101, N'A', N'she', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_101, N'B', N'her', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_101, N'C', N'hers', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_101, N'D', N'herself', 0);
        
        DECLARE @QId_102 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 102, N'Lasner Electronics'' staff have extensive -------- of current hardware systems.', N'Cần danh từ ''knowledge'' sau tính từ ''extensive''.', 102);
        SET @QId_102 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_102, N'A', N'know', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_102, N'B', N'known', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_102, N'C', N'knowledge', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_102, N'D', N'knowledgeable', 0);
        
        DECLARE @QId_103 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 103, N'-------- a year, Tarrin Industrial Supply audits the accounts of all of its factories.', N'''Once a year'' là cụm trạng từ chỉ tần suất (mỗi năm một lần).', 103);
        SET @QId_103 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_103, N'A', N'Once', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_103, N'B', N'Immediately', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_103, N'C', N'Directly', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_103, N'D', N'Yet', 0);
        
        DECLARE @QId_104 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 104, N'Ms. Pham requested a refund -------- the coffeemaker she received was damaged.', N'Liên từ ''because'' chỉ nguyên nhân phù hợp nối hai mệnh đề.', 104);
        SET @QId_104 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_104, N'A', N'despite', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_104, N'B', N'why', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_104, N'C', N'concerning', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_104, N'D', N'because', 1);
        
        DECLARE @QId_105 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 105, N'Information -------- the artwork in the lobby is available at the reception desk.', N'Giới từ ''about'' (về) đi với Information.', 105);
        SET @QId_105 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_105, N'A', N'across', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_105, N'B', N'about', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_105, N'C', N'upon', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_105, N'D', N'except', 0);
        
        DECLARE @QId_106 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 106, N'With the Gema XTl binoculars, users can see objects that are more than 100 meters away --------.', N'Trạng từ ''easily'' bổ nghĩa cho động từ see.', 106);
        SET @QId_106 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_106, N'A', N'ease', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_106, N'B', N'easy', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_106, N'C', N'easily', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_106, N'D', N'easier', 0);
        
        DECLARE @QId_107 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 107, N'The Physical Therapy Association is committed to keeping costs -------- for its certification programs.', N'Tính từ ''affordable'' (hợp lý, phải chăng) đi với keep costs.', 107);
        SET @QId_107 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_107, N'A', N'affordable', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_107, N'B', N'permitted', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_107, N'C', N'cutting', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_107, N'D', N'necessary', 0);
        
        DECLARE @QId_108 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 108, N'Mr. Brennel -------- positions in various areas of the company before he became president.', N'Động từ chia thì quá khứ đơn ''occupied'' làm vị ngữ chính.', 108);
        SET @QId_108 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_108, N'A', N'occupation', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_108, N'B', N'occupational', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_108, N'C', N'occupying', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_108, N'D', N'occupied', 1);
        
        DECLARE @QId_109 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 109, N'To remain on schedule, editors must submit all -------- to the book to the authors by Friday.', N'Danh từ ''revisions'' (bản sửa đổi) phù hợp ngữ cảnh biên tập sách.', 109);
        SET @QId_109 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_109, N'A', N'ideas', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_109, N'B', N'essays', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_109, N'C', N'revisions', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_109, N'D', N'suggestions', 0);
        
        DECLARE @QId_110 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 110, N'-------- industry professionals are allowed to purchase tickets to the Kuo Photography Fair.', N'Phó từ ''Only'' (chỉ những...) đứng đầu câu bổ nghĩa cho danh từ.', 110);
        SET @QId_110 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_110, N'A', N'Only', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_110, N'B', N'Until', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_110, N'C', N'Unless', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_110, N'D', N'Quite', 0);
        
        DECLARE @QId_111 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 111, N'At Pharmbeck''s banquet, Mr. Jones -------- a trophy for his performance in this year''s quality-improvement initiative.', N'Động từ ''accepted'' (nhận cúp/giải thưởng).', 111);
        SET @QId_111 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_111, N'A', N'accepted', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_111, N'B', N'congratulated', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_111, N'C', N'nominated', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_111, N'D', N'hoped', 0);
        
        DECLARE @QId_112 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 112, N'Ms. Suto claims that important market trends become -------- with the use of data analysis.', N'Tính từ ''predictable'' đứng sau liên động từ become.', 112);
        SET @QId_112 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_112, N'A', N'predict', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_112, N'B', N'prediction', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_112, N'C', N'predictable', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_112, N'D', N'predictably', 0);
        
        DECLARE @QId_113 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 113, N'One of Grommer Consulting''s goals is to enhance the relationship -------- salespeople and their customers.', N'Cụm ''between A and B'' (mối quan hệ giữa A và B).', 113);
        SET @QId_113 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_113, N'A', N'inside', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_113, N'B', N'within', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_113, N'C', N'around', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_113, N'D', N'between', 1);
        
        DECLARE @QId_114 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 114, N'Depending on your answers to the survey, we -------- you to collect additional information.', N'''may call'' chỉ khả năng có thể xảy ra trong tương lai theo điều kiện.', 114);
        SET @QId_114 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_114, N'A', N'may call', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_114, N'B', N'are calling', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_114, N'C', N'have been called', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_114, N'D', N'must be calling', 0);
        
        DECLARE @QId_115 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 115, N'-------- Jemburger opened its newest franchise, the first 100 customers were given free hamburgers.', N'Liên từ ''When'' (Khi mà...) nối mệnh đề trạng ngữ chỉ thời gian.', 115);
        SET @QId_115 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_115, N'A', N'Now', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_115, N'B', N'When', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_115, N'C', N'As if', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_115, N'D', N'After all', 0);
        
        DECLARE @QId_116 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 116, N'Please include the serial number of your product in any -------- with the customer service department.', N'Danh từ không đếm được ''correspondence'' (thư từ, trao đổi).', 116);
        SET @QId_116 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_116, N'A', N'corresponds', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_116, N'B', N'correspondence', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_116, N'C', N'correspondingly', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_116, N'D', N'correspondent', 0);
        
        DECLARE @QId_117 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 117, N'The award-winning film Underwater Secrets promotes awareness -------- ocean pollution and its effects on our planet.', N'Cụm ''awareness of'' (nhận thức về điều gì).', 117);
        SET @QId_117 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_117, N'A', N'of', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_117, N'B', N'from', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_117, N'C', N'with', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_117, N'D', N'by', 0);
        
        DECLARE @QId_118 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 118, N'F Company specializes in -------- promotional items to help companies advertise their brand.', N'Tính từ phân từ ''personalized'' (được cá nhân hóa) bổ nghĩa cho items.', 118);
        SET @QId_118 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_118, N'A', N'personally', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_118, N'B', N'personalized', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_118, N'C', N'personality', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_118, N'D', N'personalizes', 0);
        
        DECLARE @QId_119 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 119, N'-------- the rent increase is less than 2 percent, Selwin Electrical Supply will continue to lease the space.', N'Cụm liên từ ''As long as'' (Miễn là).', 119);
        SET @QId_119 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_119, N'A', N'As long as', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_119, N'B', N'Along with', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_119, N'C', N'Not only', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_119, N'D', N'Otherwise', 0);
        
        DECLARE @QId_120 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 120, N'Belden Hospital''s chief of staff meets regularly with the staff to ensure that procedures -------- correctly.', N'Thì hiện tại tiếp diễn thể bị động ''are being performed''.', 120);
        SET @QId_120 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_120, N'A', N'to be performed', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_120, N'B', N'would have performed', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_120, N'C', N'had been performed', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_120, N'D', N'are being performed', 1);
        
        DECLARE @QId_121 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 121, N'Any requests for time off should be addressed to the -------- department supervisor.', N'Tính từ ''appropriate'' (thích hợp, đúng thẩm quyền).', 121);
        SET @QId_121 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_121, N'A', N'urgent', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_121, N'B', N'appropriate', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_121, N'C', N'subsequent', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_121, N'D', N'deliverable', 0);
        
        DECLARE @QId_122 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 122, N'World Fish Supply delivers the freshest fish possible thanks to innovative -------- and shipping methods.', N'Danh từ ''preservation'' (sự bảo quản) đi song song với shipping methods.', 122);
        SET @QId_122 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_122, N'A', N'preserves', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_122, N'B', N'preserved', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_122, N'C', N'preserve', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_122, N'D', N'preservation', 1);
        
        DECLARE @QId_123 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 123, N'Company executives are currently reviewing the annual budget -------- submitted to them by the Financial Planning department.', N'''budget requirements'' (các yêu cầu/nhu cầu ngân sách).', 123);
        SET @QId_123 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_123, N'A', N'requirements', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_123, N'B', N'deliveries', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_123, N'C', N'developers', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_123, N'D', N'qualities', 0);
        
        DECLARE @QId_124 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 124, N'Even the CEO had to admit that Prasma Designs'' win was the result of -------- fortunate timing.', N'Trạng từ ''partly'' (một phần) bổ nghĩa cho cụm tính từ fortunate timing.', 124);
        SET @QId_124 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_124, N'A', N'parts', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_124, N'B', N'parted', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_124, N'C', N'partly', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_124, N'D', N'parting', 0);
        
        DECLARE @QId_125 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 125, N'Mr. Singh took notes on -------- the focus group discussed during the morning session.', N'Đại từ ''everything'' (mọi thứ mà nhóm đã thảo luận).', 125);
        SET @QId_125 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_125, N'A', N'each', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_125, N'B', N'several', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_125, N'C', N'another', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_125, N'D', N'everything', 1);
        
        DECLARE @QId_126 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 126, N'Last year, Tadaka Computer Solutions ranked third -------- in regional earnings.', N'Trạng từ ''overall'' (tổng thể/chung cuộc).', 126);
        SET @QId_126 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_126, N'A', N'together', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_126, N'B', N'overall', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_126, N'C', N'consecutively', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_126, N'D', N'generally', 0);
        
        DECLARE @QId_127 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 127, N'-------- the popularity of the BPT39 wireless speaker, production will be increased fivefold starting next month.', N'Cụm giới từ ''As a result of'' (Do/Bởi vì).', 127);
        SET @QId_127 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_127, N'A', N'On behalf of', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_127, N'B', N'Whether', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_127, N'C', N'Moreover', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_127, N'D', N'As a result of', 1);
        
        DECLARE @QId_128 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 128, N'Zypo Properties has just signed a lease agreement with the law firm -------- offices are on the third floor.', N'Đại từ quan hệ chỉ sở hữu ''whose'' (có các văn phòng nằm ở tầng 3).', 128);
        SET @QId_128 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_128, N'A', N'how', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_128, N'B', N'what', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_128, N'C', N'whose', 1);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_128, N'D', N'wherever', 0);
        
        DECLARE @QId_129 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 129, N'-------- events this year caused profits in the second and third quarters to differ significantly from original projections.', N'Tính từ ''Unforeseen'' (không lường trước được).', 129);
        SET @QId_129 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_129, N'A', N'Total', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_129, N'B', N'Marginal', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_129, N'C', N'Representative', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_129, N'D', N'Unforeseen', 1);
        
        DECLARE @QId_130 INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_5, NULL, 130, N'The timeline for the pathway lighting project was extended to -------- input from the environmental commission.', N'Cụm động từ ''allow for'' (cho phép/tính đến/dành chỗ cho ý kiến đóng góp).', 130);
        SET @QId_130 = SCOPE_IDENTITY();
      
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_130, N'A', N'use up', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_130, N'B', N'believe in', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_130, N'C', N'make into', 0);
        
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_130, N'D', N'allow for', 1);
        
      DECLARE @PartId_6 INT;
      INSERT INTO dbo.ExamParts (ExamId, PartNumber, Title, Instructions)
      VALUES (@ExamId, 6, N'Part 6', N'Directions: Read the texts that follow. A word, phrase, or sentence is missing in parts of each text. Four answer choices for each question are given below the text. Select the best answer to complete the text. Then mark the letter (A), (B), (C), or (D) on your answer sheet.');
      SET @PartId_6 = SCOPE_IDENTITY();
    
        DECLARE @PassageId_6_0 INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_6, N'', N'Questions 131-134 refer to the following advertisement.
With Global Strength Gym''s 30-day trial period, you get the opportunity to try out our classes, equipment, and facilities. -------- [131]. It''s completely risk-free! To sign up, we require your contact information and payment details, but you will only be charged if you are a member for -------- [132] 30 days. If you decide within this time that you no longer want to be a member of Global Strength, -------- [133] visit our Web site at www.gsgym.com. On the Membership page, elect to -------- [134] your membership and enter the necessary information. It''s that easy!', NULL, 1);
        SET @PassageId_6_0 = SCOPE_IDENTITY();
      
          DECLARE @QId_131 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_6, @PassageId_6_0, 131, N'', N'Câu A giải thích phù hợp cho câu tiếp theo: ''It''s completely risk-free!''', 131);
          SET @QId_131 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_131, N'A', N'Throughout the trial, you pay nothing and sign no contract.', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_131, N'B', N'Weight-lifting classes are not currently available.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_131, N'C', N'A cash deposit is required when you sign up for membership.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_131, N'D', N'All questions should be e-mailed to customerservice@gsgym.com.', 0);
          
          DECLARE @QId_132 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_6, @PassageId_6_0, 132, N'', N'''over 30 days'' (hơn 30 ngày) thì mới bị tính phí sau thời gian dùng thử 30 ngày.', 132);
          SET @QId_132 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_132, N'A', N'not even', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_132, N'B', N'almost', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_132, N'C', N'over', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_132, N'D', N'less than', 0);
          
          DECLARE @QId_133 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_6, @PassageId_6_0, 133, N'', N'Trạng từ ''simply'' (chỉ đơn giản là ghé thăm website).', 133);
          SET @QId_133 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_133, N'A', N'justly', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_133, N'B', N'regularly', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_133, N'C', N'evenly', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_133, N'D', N'simply', 1);
          
          DECLARE @QId_134 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_6, @PassageId_6_0, 134, N'', N'''cancel your membership'' (hủy tư cách thành viên) nếu không còn muốn làm thành viên.', 134);
          SET @QId_134 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_134, N'A', N'extend', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_134, N'B', N'renew', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_134, N'C', N'cancel', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_134, N'D', N'initiate', 0);
          
        DECLARE @PassageId_6_1 INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_6, N'', N'Questions 135-138 refer to the following instructions.
As a Hanson-Roves employee, you are entitled to paid time off for health -------- [135]. To avoid deductions to your pay, you -------- [136] to provide a physician-signed note as documentation of your illness. -------- [137] should include the date you were seen by the doctor, a statement certifying that you are unable to perform the duties of your position, and your expected date of return. Your supervisor will then forward the documentation to Human Resources. -------- [138]. Employee health records can be accessed only by those with a valid business reason for reviewing them.', NULL, 2);
        SET @PassageId_6_1 = SCOPE_IDENTITY();
      
          DECLARE @QId_135 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_6, @PassageId_6_1, 135, N'', N'''health reasons'' (lý do sức khỏe).', 135);
          SET @QId_135 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_135, N'A', N'reasons', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_135, N'B', N'origins', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_135, N'C', N'senses', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_135, N'D', N'contributions', 0);
          
          DECLARE @QId_136 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_6, @PassageId_6_1, 136, N'', N'Thể bị động hiện tại đơn ''are required to'' (bạn được yêu cầu phải cung cấp giấy bác sĩ).', 136);
          SET @QId_136 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_136, N'A', N'were required', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_136, N'B', N'require', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_136, N'C', N'are required', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_136, N'D', N'are requiring', 0);
          
          DECLARE @QId_137 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_6, @PassageId_6_1, 137, N'', N'''This note'' hoặc đại từ thay thế cho physician-signed note.', 137);
          SET @QId_137 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_137, N'A', N'Those', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_137, N'B', N'They', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_137, N'C', N'This note', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_137, N'D', N'These', 0);
          
          DECLARE @QId_138 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_6, @PassageId_6_1, 138, N'', N'Câu A phù hợp với câu tiếp theo về tính bảo mật của hồ sơ sức khỏe.', 138);
          SET @QId_138 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_138, N'A', N'Hanson-Roves ensures the privacy of your health information.', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_138, N'B', N'Absences may be caused by a number of factors.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_138, N'C', N'You should then explain why a physician''s note is not available.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_138, N'D', N'Take note of the duties you were originally assigned.', 0);
          
        DECLARE @PassageId_6_2 INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_6, N'', N'Questions 139-142 refer to the following e-mail.
To: fcontini@attmail.com
From: btakemoto@arolischems.co.uk
Date: 15 July
Subject: Your first day at Arolis
Dear Mr. Contini,
Welcome to Arolis Chemicals! Thank you for -------- [139] the full-time, permanent position of laboratory assistant. We look forward to your arrival on 1 August in the Harris Building. Please report to the front desk and ask for Jack McNolan. He -------- [140] you to the Human Resources office. There, you will obtain your employee badge -------- [141] all documents necessary to start work. Note that because of its large size, the Leicester campus of Arolis can be difficult to navigate. Studying a campus map will help orient you to the location of the different buildings. -------- [142]. Should you have any questions, please do not hesitate to contact me.
Sincerely,
Brandon Takemoto
HR Administrative Officer', NULL, 3);
        SET @PassageId_6_2 = SCOPE_IDENTITY();
      
          DECLARE @QId_139 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_6, @PassageId_6_2, 139, N'', N'''accepting'' (cảm ơn vì đã đồng ý nhận vị trí công việc).', 139);
          SET @QId_139 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_139, N'A', N'offering', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_139, N'B', N'accepting', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_139, N'C', N'discussing', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_139, N'D', N'advertising', 0);
          
          DECLARE @QId_140 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_6, @PassageId_6_2, 140, N'', N'Thì tương lai đơn ''will accompany'' (anh ấy sẽ dẫn bạn đến phòng nhân sự).', 140);
          SET @QId_140 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_140, N'A', N'accompany', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_140, N'B', N'did accompany', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_140, N'C', N'accompanies', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_140, N'D', N'will accompany', 1);
          
          DECLARE @QId_141 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_6, @PassageId_6_2, 141, N'', N'Liên từ ''as well as'' (cũng như tất cả các tài liệu cần thiết).', 141);
          SET @QId_141 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_141, N'A', N'too', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_141, N'B', N'also', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_141, N'C', N'as well as', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_141, N'D', N'additionally', 0);
          
          DECLARE @QId_142 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_6, @PassageId_6_2, 142, N'', N'''You can download one [map] from our Web site.''', 142);
          SET @QId_142 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_142, N'A', N'Please sign all the documents.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_142, N'B', N'I will provide you with a replacement.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_142, N'C', N'Construction will be completed next year.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_142, N'D', N'You can download one from our Web site.', 1);
          
        DECLARE @PassageId_6_3 INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_6, N'', N'Questions 143-146 refer to the following article.
(18 April)—MKZ Foods, Inc., the region''s largest exporter of pecans, expects its outgoing shipments to increase significantly over the next few months. This -------- [143] is based on the fact that the region''s pecan farmers expanded their land area by 20 percent last year. According to spokesperson Katharina Seiler, MKZ''s exports could reach a colossal 50,000 metric tons this year. -------- [144]. MKZ buys most of the yield from the region''s pecan farms and processes it -------- [145] export throughout the world. "The availability of new land for -------- [146] in the region is creating opportunities for growth," said Ms. Seiler. "I believe MKZ is going to have a truly outstanding year."', NULL, 4);
        SET @PassageId_6_3 = SCOPE_IDENTITY();
      
          DECLARE @QId_143 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_6, @PassageId_6_3, 143, N'', N'''forecast'' (dự báo này dựa trên thực tế là...).', 143);
          SET @QId_143 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_143, N'A', N'cost', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_143, N'B', N'delay', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_143, N'C', N'decision', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_143, N'D', N'forecast', 1);
          
          DECLARE @QId_144 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_6, @PassageId_6_3, 144, N'', N'50,000 tấn là một con số chưa từng có (unprecedented) trong lịch sử công ty.', 144);
          SET @QId_144 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_144, N'A', N'Such a figure is unprecedented in the company''s history.', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_144, N'B', N'Moreover, Ms. Seiler holds an advanced degree in economics.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_144, N'C', N'Pecans are high in vitamins and minerals.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_144, N'D', N'Still, MKZ shares have been profitable in recent years.', 0);
          
          DECLARE @QId_145 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_6, @PassageId_6_3, 145, N'', N'Giới từ ''for'' (for export: dành cho xuất khẩu).', 145);
          SET @QId_145 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_145, N'A', N'on', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_145, N'B', N'for', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_145, N'C', N'in', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_145, N'D', N'by', 0);
          
          DECLARE @QId_146 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_6, @PassageId_6_3, 146, N'', N'Danh động từ ''farming'' (diện tích đất mới cho việc canh tác/trồng trọt).', 146);
          SET @QId_146 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_146, N'A', N'farming', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_146, N'B', N'farmer', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_146, N'C', N'farmed', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_146, N'D', N'farm', 0);
          
      DECLARE @PartId_7 INT;
      INSERT INTO dbo.ExamParts (ExamId, PartNumber, Title, Instructions)
      VALUES (@ExamId, 7, N'Part 7', N'Directions: In this part you will read a selection of texts, such as magazine and newspaper articles, e-mails, and instant messages. Each text or set of texts is followed by several questions. Select the best answer for each question and mark the letter (A), (B), (C), or (D) on your answer sheet.');
      SET @PartId_7 = SCOPE_IDENTITY();
    
        DECLARE @PassageId_7_0 INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_7, N'', N'Questions 147-148 refer to the following text message conversation.
Amy Han (10:14 A.M.):
Hi, Ms. Brown. Are you still meeting with the board of directors this afternoon regarding the redesign proposal for their downtown office buildings?
Dana Brown (10:16 A.M.):
Yes, I am. But I realized that I don''t have the full set of plans with me. Could you ask Ziva to send a messenger with a copy of the Grainger Centre files?
Amy Han (10:18 A.M.):
Sure, I''ll have her do that right away so you''ll have them before the meeting starts at 2:00 P.M.', N'image29.jpg', 1);
        SET @PassageId_7_0 = SCOPE_IDENTITY();
      
          DECLARE @QId_147 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_0, 147, N'Where does Ms. Brown most likely work?', N'Bà Brown thảo luận về thiết kế kiến trúc tòa nhà (redesign proposal, full set of plans).', 147);
          SET @QId_147 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_147, N'A', N'At an accounting firm', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_147, N'B', N'At an architectural firm', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_147, N'C', N'At a Web design company', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_147, N'D', N'At a market research company', 0);
          
          DECLARE @QId_148 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_0, 148, N'What is Ziva asked to do?', N'Gửi bản vẽ/hồ sơ thiết kế (send a copy of the Grainger Centre files) qua người chuyển phát.', 148);
          SET @QId_148 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_148, N'A', N'Reply to a text message', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_148, N'B', N'Create a portfolio', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_148, N'C', N'Set up a meeting', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_148, N'D', N'Send a work sample', 1);
          
        DECLARE @PassageId_7_1 INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_7, N'', N'Questions 149-150 refer to the following e-mail.
To: All Store Managers <managers@trevorretail.com>
From: Craig Welch <c.welch@trevorretail.com>
Date: October 4
Subject: Upcoming Seasonal Clearance Event
Dear Managers,
Our annual autumn clearance event will begin next Monday, October 11. All retail outlets will offer discounts of up to 40% on selected seasonal apparel. Please ensure that promotional banners are displayed prominently at the entrance of your store by Sunday evening. In addition, store managers have discretion to decide which specific clearance racks to place near the front checkout counters to maximize foot traffic.
Thank you for your cooperation,
Craig Welch
Director of Retail Operations', N'image31.jpg', 2);
        SET @PassageId_7_1 = SCOPE_IDENTITY();
      
          DECLARE @QId_149 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_1, 149, N'What is the purpose of the e-mail?', N'Thông báo và hướng dẫn sự kiện giảm giá thanh lý mùa thu sắp tới.', 149);
          SET @QId_149 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_149, N'A', N'To request a sales report', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_149, N'B', N'To announce a new policy', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_149, N'C', N'To discuss a fashion trend', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_149, N'D', N'To describe an upcoming sale', 1);
          
          DECLARE @QId_150 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_1, 150, N'According to the e-mail, what will managers do?', N'Các quản lý được quyết định cách sắp xếp, trưng bày các quầy hàng thanh lý.', 150);
          SET @QId_150 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_150, N'A', N'Decide how to display new merchandise', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_150, N'B', N'Train staff to use the cash register', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_150, N'C', N'Help customers with special requests', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_150, N'D', N'Decide what items get price discounts', 0);
          
        DECLARE @PassageId_7_2 INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_7, N'', N'Questions 151-152 refer to the following Web page.
Carmont Media Careers - Culture & Values (https://www.carmontmedia.co.tt)
At Carmont Media, our work culture is driven by a shared mission: enriching listeners'' minds through quality radio programming, podcasts, and digital journalism. We actively recruit talented individuals from diverse backgrounds to reflect the diverse communities we serve. Our employees enjoy generous health benefits, flexible working arrangements, and continuous professional development workshops. If you are passionate about storytelling and sound engineering, explore our open positions today!', N'image38.jpg', 3);
        SET @PassageId_7_2 = SCOPE_IDENTITY();
      
          DECLARE @QId_151 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_2, 151, N'What is indicated about Carmont Media?', N'Công ty sản xuất các chương trình radio, podcast và âm thanh (produces audio content).', 151);
          SET @QId_151 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_151, N'A', N'It has recently opened an office abroad.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_151, N'B', N'It produces audio content.', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_151, N'C', N'It is currently renovating its studios.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_151, N'D', N'It won an award for investigative journalism.', 0);
          
          DECLARE @QId_152 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_2, 152, N'What benefit is mentioned on the Web page?', N'Bài viết đề cập rõ ''flexible working arrangements''.', 152);
          SET @QId_152 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_152, N'A', N'Free public transit passes', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_152, N'B', N'Flexible working arrangements', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_152, N'C', N'Tuition reimbursement', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_152, N'D', N'Childcare subsidies', 0);
          
        DECLARE @PassageId_7_3 INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_7, N'', N'Questions 153-154 refer to the following notice.
Springdale Municipal Library - Computer Lab Upgrade Notice
Please be advised that the computer lab on the second floor will be temporarily closed from Thursday, March 12 through Saturday, March 14 for hardware and software upgrades. During this period, thirty new desktop workstations will be installed, and high-speed Wi-Fi access points will be replaced.
Patrons who need access to printing or Internet services are encouraged to use the temporary laptop stations set up in the first-floor reading lounge. The computer lab will resume normal operating hours on Monday, March 16. We apologize for any inconvenience.', NULL, 4);
        SET @PassageId_7_3 = SCOPE_IDENTITY();
      
          DECLARE @QId_153 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_3, 153, N'What is the purpose of the notice?', N'Thông báo phòng máy tính tạm ngừng hoạt động để nâng cấp.', 153);
          SET @QId_153 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_153, N'A', N'To announce a temporary service interruption', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_153, N'B', N'To introduce new library personnel', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_153, N'C', N'To advertise computer classes', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_153, N'D', N'To solicit donations for new computers', 0);
          
          DECLARE @QId_154 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_3, 154, N'What can library patrons do on March 13?', N'Sử dụng các trạm laptop tạm thời ở tầng 1.', 154);
          SET @QId_154 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_154, N'A', N'Attend a technology seminar', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_154, N'B', N'Borrow desktop monitors', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_154, N'C', N'Use laptop stations on the first floor', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_154, N'D', N'Reserve private study rooms', 0);
          
        DECLARE @PassageId_7_4 INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_7, N'', N'Questions 155-157 refer to the following online chat discussion.
Kenji Sato (2:10 P.M.):
Has anyone reviewed the shipment of ceramic tiles received from Moreno Ceramics this morning?
Elena Gomez (2:12 P.M.):
I inspected the pallets about twenty minutes ago. Unfortunately, four boxes in pallet C were cracked during transit.
Kenji Sato (2:14 P.M.):
That''s problematic because the Henderson hotel renovation project begins on Friday, and we need all 120 boxes.
Elena Gomez (2:16 P.M.):
I just spoke with Carlos Moreno. He said their local distribution warehouse in Queens has extra stock and can dispatch a replacement truck by 9:00 A.M. tomorrow.
Kenji Sato (2:17 P.M.):
That works out perfectly. Thanks for handling it so quickly, Elena!', NULL, 5);
        SET @PassageId_7_4 = SCOPE_IDENTITY();
      
          DECLARE @QId_155 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_4, 155, N'What problem does Elena Gomez report?', N'Một số hộp gạch men bị nứt vỡ trong quá trình vận chuyển.', 155);
          SET @QId_155 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_155, N'A', N'A delivery was sent to the wrong address.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_155, N'B', N'Some merchandise was damaged.', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_155, N'C', N'An order was delayed at customs.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_155, N'D', N'The wrong color tiles were shipped.', 0);
          
          DECLARE @QId_156 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_4, 156, N'When is the Henderson project scheduled to begin?', N'Kenji nói dự án bắt đầu vào thứ Sáu (Friday).', 156);
          SET @QId_156 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_156, N'A', N'On Wednesday', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_156, N'B', N'On Thursday', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_156, N'C', N'On Friday', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_156, N'D', N'Next week', 0);
          
          DECLARE @QId_157 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_4, 157, N'What will happen by 9:00 A.M. tomorrow?', N'Kho phân phối sẽ gửi chuyến xe chở hàng thay thế.', 157);
          SET @QId_157 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_157, N'A', N'A replacement delivery will be sent.', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_157, N'B', N'A contract will be signed.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_157, N'C', N'An insurance inspector will arrive.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_157, N'D', N'A refund will be issued.', 0);
          
        DECLARE @PassageId_7_5 INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_7, N'', N'Questions 158-160 refer to the following schedule.
City of Oakville - Annual Community Arts & Crafts Fair
Location: Riverside Park | Date: Saturday, July 18
Schedule of Events:
- 09:00 A.M. - Opening Ceremony & Vendor Booths Open
- 10:30 A.M. - Watercolor Painting Workshop (Instructor: Maya Lin)
- 01:00 P.M. - Live Acoustic Music by The River Trio
- 02:30 P.M. - Pottery Demonstration & Hands-On Wheel Throwing (Instructor: David Ortiz)
- 04:30 P.M. - Awards for Best Artisan Showcase
- 06:00 P.M. - Fair Concludes
Note: Registration for the workshops is free but requires advance sign-up at the information booth near the main entrance.', NULL, 6);
        SET @PassageId_7_5 = SCOPE_IDENTITY();
      
          DECLARE @QId_158 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_5, 158, N'What is taking place at Riverside Park on July 18?', N'Hội chợ thủ công và nghệ thuật cộng đồng thường niên.', 158);
          SET @QId_158 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_158, N'A', N'A food festival', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_158, N'B', N'An arts and crafts fair', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_158, N'C', N'A sports tournament', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_158, N'D', N'A photography exhibition', 0);
          
          DECLARE @QId_159 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_5, 159, N'Who is leading the pottery demonstration?', N'David Ortiz là người hướng dẫn phần làm gốm.', 159);
          SET @QId_159 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_159, N'A', N'Maya Lin', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_159, N'B', N'The River Trio', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_159, N'C', N'David Ortiz', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_159, N'D', N'Oakville City Council', 0);
          
          DECLARE @QId_160 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_5, 160, N'What is required to participate in a workshop?', N'Cần đăng ký trước tại quầy thông tin gần lối vào.', 160);
          SET @QId_160 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_160, N'A', N'Paying an admission fee', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_160, N'B', N'Bringing personal tools', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_160, N'C', N'Signing up at the information booth', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_160, N'D', N'Holding a city resident card', 0);
          
        DECLARE @PassageId_7_6 INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_7, N'', N'Questions 161-163 refer to the following letter.
Vanguard Office Solutions
742 Industrial Parkway, Cleveland, OH 44103
August 22
Mr. Gregory Vance
Apex Logistics
100 Harbor View Drive, Cleveland, OH 44114
Dear Mr. Vance,
Thank you for your inquiry regarding our modular ergonomic desk systems. Based on the specifications you provided for your new regional headquarters, we recommend our Model X-400 height-adjustable desks with integrated power outlets and cable management trays.
We are pleased to offer a 15% volume discount for orders exceeding fifty units, along with complimentary delivery and on-site assembly by our certified technicians. Enclosed you will find our comprehensive catalog and pricing sheet. If you would like to test a sample unit at your office, we can arrange a seven-day trial at no obligation.
Sincerely,
Rachel Foster
Senior Sales Consultant', N'image59.jpg', 7);
        SET @PassageId_7_6 = SCOPE_IDENTITY();
      
          DECLARE @QId_161 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_6, 161, N'Why did Ms. Foster write the letter?', N'Phản hồi thư hỏi thông tin về bàn làm việc công thái học.', 161);
          SET @QId_161 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_161, N'A', N'To respond to an inquiry about office furniture', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_161, N'B', N'To confirm a delivery date', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_161, N'C', N'To notify a client of a price increase', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_161, N'D', N'To request payment for an overdue bill', 0);
          
          DECLARE @QId_162 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_6, 162, N'What is offered for orders of more than 50 units?', N'Chiết khấu 15% khi đặt trên 50 bàn.', 162);
          SET @QId_162 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_162, N'A', N'A free laptop stand', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_162, N'B', N'A 15% volume discount', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_162, N'C', N'Extended warranty coverage', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_162, N'D', N'Custom color engraving', 0);
          
          DECLARE @QId_163 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_6, 163, N'What does Ms. Foster suggest Mr. Vance do?', N'Dùng thử mẫu bàn trong vòng 7 ngày không ràng buộc.', 163);
          SET @QId_163 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_163, N'A', N'Visit their factory showroom', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_163, N'B', N'Test a sample unit for seven days', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_163, N'C', N'Submit a credit application', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_163, N'D', N'Attend an ergonomics seminar', 0);
          
        DECLARE @PassageId_7_7 INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_7, N'', N'Questions 164-167 refer to the following magazine article.
GreenTech Innovations Expands Solar Panel Production
By Ronald Sterling
SEATTLE (November 12)—GreenTech Innovations, a pioneering manufacturer of renewable energy equipment, announced yesterday that it will invest $45 million to expand its manufacturing facility in Spokane, Washington. The expansion will add 80,000 square feet of state-of-the-art automated assembly lines, effectively doubling the company''s annual output of high-efficiency solar panels.
According to Chief Executive Officer Dr. Aris Thorne, the decision comes in response to unprecedented demand from commercial real estate developers seeking to comply with new federal energy efficiency guidelines. Construction on the expanded facility is slated to begin next February, with full commercial operation anticipated by the fourth quarter of next year. The project is projected to create approximately 250 new high-skilled manufacturing and engineering jobs in the greater Spokane area.', NULL, 8);
        SET @PassageId_7_7 = SCOPE_IDENTITY();
      
          DECLARE @QId_164 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_7, 164, N'What is the main topic of the article?', N'Mở rộng nhà máy sản xuất thiết bị năng lượng mặt trời tại Spokane.', 164);
          SET @QId_164 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_164, N'A', N'A merger between two energy corporations', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_164, N'B', N'The expansion of a solar equipment factory', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_164, N'C', N'The retirement of a technology CEO', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_164, N'D', N'A new government environmental tax', 0);
          
          DECLARE @QId_165 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_7, 165, N'What will the $45 million investment achieve?', N'Nhân đôi sản lượng hàng năm của các tấm pin mặt trời.', 165);
          SET @QId_165 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_165, N'A', N'Lower electricity bills for local residents', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_165, N'B', N'Double the company''s production of solar panels', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_165, N'C', N'Fund scientific scholarships at universities', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_165, N'D', N'Establish retail showrooms across the nation', 0);
          
          DECLARE @QId_166 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_7, 166, N'Why is demand for GreenTech''s panels increasing?', N'Các nhà phát triển bất động sản cần tuân thủ quy định tiêu chuẩn năng lượng.', 166);
          SET @QId_166 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_166, N'A', N'They are significantly cheaper than competitors''.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_166, N'B', N'Developers must meet federal energy standards.', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_166, N'C', N'The panels work efficiently in cold climates.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_166, N'D', N'A celebrity endorsed the company''s products.', 0);
          
          DECLARE @QId_167 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_7, 167, N'When is the expanded facility expected to be fully operational?', N'Vào quý 4 năm sau (fourth quarter of next year).', 167);
          SET @QId_167 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_167, N'A', N'In November', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_167, N'B', N'Next February', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_167, N'C', N'By the fourth quarter of next year', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_167, N'D', N'In two years', 0);
          
        DECLARE @PassageId_7_8 INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_7, N'', N'Questions 168-171 refer to the following email and evaluation form.
To: Hannah Abbott <h.abbott@lintonhotel.com>
From: Marcus Brody <m.brody@apexevents.com>
Date: May 15
Subject: Conference Feedback - Linton Grand Hotel
Dear Ms. Abbott,
On behalf of the Apex Events team, I want to express our gratitude for hosting our Annual Tech Summit on May 12–13. The catering was extraordinary, and our attendees appreciated the swift check-in process. However, several speakers in Conference Room B noted that the audio-visual projection screens flickered periodically during their presentations. We would appreciate it if your engineering team could inspect the equipment before our next scheduled gathering in September.
Feedback Summary Table:
- Venue Ambiance: Excellent (5/5)
- Catering & Refreshments: Excellent (5/5)
- Staff Courtesy: Excellent (5/5)
- Audio/Visual Equipment: Satisfactory (3/5) - Note: Projector flickering in Room B', NULL, 9);
        SET @PassageId_7_8 = SCOPE_IDENTITY();
      
          DECLARE @QId_168 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_8, 168, N'Why did Mr. Brody send the email?', N'Gửi phản hồi và đánh giá về địa điểm tổ chức hội nghị.', 168);
          SET @QId_168 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_168, N'A', N'To cancel an upcoming reservation', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_168, N'B', N'To provide feedback on a conference venue', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_168, N'C', N'To request a discount on catering', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_168, N'D', N'To apply for an event planner position', 0);
          
          DECLARE @QId_169 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_8, 169, N'What aspect of the venue received praise?', N'Đồ ăn phục vụ và thủ tục check-in nhanh chóng.', 169);
          SET @QId_169 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_169, N'A', N'The spacious parking lot', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_169, N'B', N'The catering and check-in process', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_169, N'C', N'The outdoor courtyard', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_169, N'D', N'The guest room pricing', 0);
          
          DECLARE @QId_170 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_8, 170, N'What issue was reported in Conference Room B?', N'Màn hình máy chiếu bị nhấp nháy định kỳ.', 170);
          SET @QId_170 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_170, N'A', N'The air conditioning was too cold.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_170, N'B', N'The room capacity was exceeded.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_170, N'C', N'The projection screens flickered.', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_170, N'D', N'The microphones did not work.', 0);
          
          DECLARE @QId_171 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_8, 171, N'When will Apex Events likely host another event at the hotel?', N'Vào tháng 9 tới (in September).', 171);
          SET @QId_171 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_171, N'A', N'In May', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_171, N'B', N'In July', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_171, N'C', N'In September', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_171, N'D', N'Next year', 0);
          
        DECLARE @PassageId_7_9 INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_7, N'', N'Questions 172-175 refer to the following advertisement and online review.
Advertisement:
AuraSound Pro Wireless Headphones
Engineered for audiophiles. Featuring industry-leading active noise cancellation, 40 hours of battery life on a single charge, and plush memory foam ear cushions for all-day comfort. Available in Matte Black, Silver, and Midnight Blue. Retail price: $249. Order online at www.aurasound.com to receive a complimentary hardshell carrying case!
Customer Review (Posted by Derek Shaw):
Rating: 4.5 / 5 Stars
I purchased the AuraSound Pro headphones in Silver two weeks ago for my daily train commute. The noise cancellation is phenomenal—it completely silences the rumbling train tracks. The sound profile is crisp, and the battery easily lasted through an entire week of use without needing a recharge. My only minor critique is that the headband feels slightly snug after wearing them for more than three hours continuously, but overall, they are well worth the investment.', NULL, 10);
        SET @PassageId_7_9 = SCOPE_IDENTITY();
      
          DECLARE @QId_172 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_9, 172, N'What feature of AuraSound Pro is highlighted in the ad?', N'Thời lượng pin 40 tiếng sau một lần sạc.', 172);
          SET @QId_172 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_172, N'A', N'Water resistance for swimming', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_172, N'B', N'40 hours of battery life', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_172, N'C', N'Voice assistant integration', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_172, N'D', N'Solar charging capability', 0);
          
          DECLARE @QId_173 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_9, 173, N'What bonus is offered for ordering online?', N'Tặng kèm bao đựng hộp cứng bảo vệ.', 173);
          SET @QId_173 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_173, N'A', N'Free shipping', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_173, N'B', N'A 20% discount coupon', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_173, N'C', N'A hardshell carrying case', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_173, N'D', N'An extra audio cable', 0);
          
          DECLARE @QId_174 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_9, 174, N'Why did Derek Shaw buy the headphones?', N'Sử dụng khi đi lại hàng ngày trên tàu hỏa.', 174);
          SET @QId_174 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_174, N'A', N'For studio music mixing', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_174, N'B', N'For use during his train commute', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_174, N'C', N'For gaming tournaments', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_174, N'D', N'As a birthday gift for a colleague', 0);
          
          DECLARE @QId_175 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_9, 175, N'What did Derek Shaw note as a minor drawback?', N'Vòng đeo đầu hơi chật khi đeo liên tục quá 3 tiếng.', 175);
          SET @QId_175 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_175, N'A', N'The battery drains faster than advertised.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_175, N'B', N'The headband feels slightly snug after extended wear.', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_175, N'C', N'The Bluetooth connection dropped often.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_175, N'D', N'The color was different from the photos.', 0);
          
        DECLARE @PassageId_7_10 INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_7, N'', N'Questions 176-180 refer to the following email and training seminar schedule.
Email:
To: All Department Supervisors <supervisors@novasolutions.com>
From: Brenda Vance <b.vance@novasolutions.com>
Date: January 14
Subject: Q1 Leadership & Compliance Workshops
Dear Supervisors,
As part of our commitment to professional excellence, all departmental leads are required to attend at least two half-day training modules during the upcoming Q1 Leadership Series. Please review the attached schedule and register for your preferred sessions by January 25. Note that Session 3 on ''Data Privacy in Cloud Environments'' is mandatory for all IT and Financial supervisors.
Schedule:
- Session 1: Effective Conflict Resolution | Feb 5, 9:00 A.M.–12:30 P.M. | Room 101 | Trainer: Dr. Alan Ross
- Session 2: Agile Project Management Tools | Feb 12, 1:00 P.M.–4:30 P.M. | Room 104 | Trainer: Karen Diaz
- Session 3: Data Privacy in Cloud Environments | Feb 19, 9:00 A.M.–12:30 P.M. | Main Auditorium | Trainer: Vikram Patel
- Session 4: Performance Review Coaching | Feb 26, 1:00 P.M.–4:30 P.M. | Room 102 | Trainer: Brenda Vance', NULL, 11);
        SET @PassageId_7_10 = SCOPE_IDENTITY();
      
          DECLARE @QId_176 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_10, 176, N'What is the purpose of the email?', N'Thông báo cho các quản lý bộ phận về các khóa đào tạo bắt buộc.', 176);
          SET @QId_176 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_176, N'A', N'To announce employee promotions', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_176, N'B', N'To notify supervisors of mandatory training sessions', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_176, N'C', N'To solicit nominations for department leads', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_176, N'D', N'To update workplace safety policies', 0);
          
          DECLARE @QId_177 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_10, 177, N'By what date must supervisors register for sessions?', N'Hạn chót đăng ký là ngày 25 tháng 1.', 177);
          SET @QId_177 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_177, N'A', N'January 14', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_177, N'B', N'January 25', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_177, N'C', N'February 5', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_177, N'D', N'February 26', 0);
          
          DECLARE @QId_178 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_10, 178, N'Which session is compulsory for Finance supervisors?', N'Session 3 (Data Privacy) là bắt buộc cho IT và Tài chính.', 178);
          SET @QId_178 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_178, N'A', N'Session 1', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_178, N'B', N'Session 2', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_178, N'C', N'Session 3', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_178, N'D', N'Session 4', 0);
          
          DECLARE @QId_179 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_10, 179, N'Who will lead the workshop on Performance Review Coaching?', N'Brenda Vance là người giảng dạy Session 4.', 179);
          SET @QId_179 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_179, N'A', N'Dr. Alan Ross', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_179, N'B', N'Karen Diaz', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_179, N'C', N'Vikram Patel', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_179, N'D', N'Brenda Vance', 1);
          
          DECLARE @QId_180 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_10, 180, N'Where will the Data Privacy workshop take place?', N'Được tổ chức tại Main Auditorium (Hội trường chính).', 180);
          SET @QId_180 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_180, N'A', N'Room 101', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_180, N'B', N'Room 104', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_180, N'C', N'Main Auditorium', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_180, N'D', N'Room 102', 0);
          
        DECLARE @PassageId_7_11 INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_7, N'', N'Questions 181-185 refer to the following policy document and memorandum.
Document: Silverline Logistics Travel Reimbursement Policy
Employees traveling on authorized company business are eligible for expense reimbursement under the following guidelines:
1. Lodging: Up to $180 per night in standard tier cities, up to $250 per night in designated high-cost metropolitan areas (New York, San Francisco, London).
2. Meals: Daily per diem allowance of $65 for domestic travel. Itemized receipts are required for all meals exceeding $25.
3. Transportation: Economy class airfare booked at least 14 days in advance. Ride-share or taxi fares between hotel and client sites are reimbursable.
4. Submission: All expense reports must be submitted via the Concur portal within 10 business days of returning from the trip.
Memorandum:
To: Sales Representatives
From: Patricia Locke, Travel Coordinator
Date: March 8
Subject: Travel to European Trade Expo
Please remember that London is classified as a high-cost area. When submitting your lodging claims for the expo, ensure your room rate does not exceed the allowed $250 cap. For flights, our preferred travel agency has reserved a block of seats on British Airways.', N'image75.jpg', 12);
        SET @PassageId_7_11 = SCOPE_IDENTITY();
      
          DECLARE @QId_181 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_11, 181, N'What is the daily meal per diem for domestic travel?', N'Mức công tác phí ăn uống hàng ngày là $65.', 181);
          SET @QId_181 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_181, N'A', N'$25', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_181, N'B', N'$65', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_181, N'C', N'$180', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_181, N'D', N'$250', 0);
          
          DECLARE @QId_182 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_11, 182, N'When must expense reports be submitted?', N'Trong vòng 10 ngày làm việc sau khi kết thúc chuyến công tác.', 182);
          SET @QId_182 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_182, N'A', N'Prior to departure', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_182, N'B', N'Within 5 days of travel', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_182, N'C', N'Within 10 business days of returning', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_182, N'D', N'At the end of the fiscal quarter', 0);
          
          DECLARE @QId_183 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_11, 183, N'What maximum hotel rate applies to employees traveling to London?', N'London là khu vực đắt đỏ (high-cost), tối đa $250/đêm.', 183);
          SET @QId_183 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_183, N'A', N'$150', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_183, N'B', N'$180', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_183, N'C', N'$220', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_183, N'D', N'$250', 1);
          
          DECLARE @QId_184 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_11, 184, N'What is stated about airline tickets?', N'Vé máy bay hạng phổ thông (economy) phải đặt trước ít nhất 14 ngày.', 184);
          SET @QId_184 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_184, N'A', N'They must be booked in business class.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_184, N'B', N'They must be booked at least 14 days in advance in economy.', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_184, N'C', N'They are non-refundable.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_184, N'D', N'Employees must use their personal airline miles.', 0);
          
          DECLARE @QId_185 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_11, 185, N'Why did Ms. Locke send the memorandum?', N'Nhắc nhở nhân viên kinh doanh các quy định khi đi công tác London.', 185);
          SET @QId_185 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_185, N'A', N'To remind staff about travel rules for an upcoming London trip', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_185, N'B', N'To announce a reduction in meal allowances', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_185, N'C', N'To cancel an international trade delegation', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_185, N'D', N'To introduce a new travel booking software', 0);
          
        DECLARE @PassageId_7_12 INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_7, N'', N'Questions 186-190 refer to the following job posting, email, and reference letter.
Text 1: Job Posting - Senior Data Analyst at Horizon Analytics
Horizon Analytics is seeking a Senior Data Analyst to join our Boston office. The ideal candidate will possess at least 4 years of experience in predictive modeling, expertise in Python and SQL, and demonstrated ability to present technical findings to non-technical stakeholders. We offer competitive salary, 401(k) matching, and annual performance bonuses.
Text 2: Email Application
To: careers@horizonanalytics.com
From: rachel.choi@fastmail.com
Date: April 18
Dear Hiring Committee,
I am writing to apply for the Senior Data Analyst position. For the past five years, I have worked at Quantico Financial, where I led a team of three analysts in building churn prediction models that increased customer retention by 18%. I hold a Master''s degree in Statistics from Boston University. Attached are my resume and portfolio.
Text 3: Reference Letter from Quantico Financial
To Whom It May Concern,
Rachel Choi was an invaluable asset to our analytics team from 2021 to 2026. Her technical proficiency in Python and statistical modeling is exceptional, and she consistently met tight deadlines with accuracy. I recommend her without reservation.
Sincerely,
Markus Lindqvist, VP of Analytics', NULL, 13);
        SET @PassageId_7_12 = SCOPE_IDENTITY();
      
          DECLARE @QId_186 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_12, 186, N'What is a requirement for the Senior Data Analyst position?', N'Yêu cầu có ít nhất 4 năm kinh nghiệm làm việc.', 186);
          SET @QId_186 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_186, N'A', N'A Ph.D. in Computer Science', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_186, N'B', N'At least 4 years of experience', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_186, N'C', N'Fluency in three languages', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_186, N'D', N'Willingness to travel 50% of the time', 0);
          
          DECLARE @QId_187 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_12, 187, N'What achievement does Ms. Choi highlight in her email?', N'Xây dựng mô hình giúp tăng tỷ lệ giữ chân khách hàng thêm 18%.', 187);
          SET @QId_187 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_187, N'A', N'Designing a popular mobile application', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_187, N'B', N'Increasing customer retention by 18%', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_187, N'C', N'Publishing a textbook on statistics', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_187, N'D', N'Securing a $2 million venture capital grant', 0);
          
          DECLARE @QId_188 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_12, 188, N'Where did Ms. Choi earn her Master''s degree?', N'Bằng Thạc sĩ Thống kê tại Boston University.', 188);
          SET @QId_188 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_188, N'A', N'Harvard University', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_188, N'B', N'Boston University', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_188, N'C', N'MIT', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_188, N'D', N'Columbia University', 0);
          
          DECLARE @QId_189 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_12, 189, N'Who provided a recommendation letter for Ms. Choi?', N'Phó chủ tịch Markus Lindqvist tại công ty cũ Quantico Financial.', 189);
          SET @QId_189 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_189, N'A', N'Her university professor', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_189, N'B', N'The CEO of Horizon Analytics', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_189, N'C', N'Her former supervisor, Markus Lindqvist', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_189, N'D', N'A client from a retail firm', 0);
          
          DECLARE @QId_190 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_12, 190, N'What quality of Ms. Choi is praised in the reference letter?', N'Chuyên môn kỹ thuật và khả năng hoàn thành công việc đúng hạn.', 190);
          SET @QId_190 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_190, N'A', N'Her graphic design skills', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_190, N'B', N'Her public speaking charisma', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_190, N'C', N'Her technical proficiency and ability to meet deadlines', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_190, N'D', N'Her sales negotiation talent', 0);
          
        DECLARE @PassageId_7_13 INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_7, N'', N'Questions 191-195 refer to the following customer inquiry, dispatch log, and reply email.
Text 1: Customer Inquiry (Mr. Kenji Koshi)
Date: August 5
I am writing to report that the air conditioning unit (Model CoolMax 500) installed in my retail boutique on July 28 has stopped cooling properly. Yesterday afternoon, the temperature inside the store reached 29°C, forcing us to close two hours early. Please send a certified technician immediately to inspect the compressor.
Text 2: Service Dispatch Log
- Service Ticket: #84920
- Customer: Kenji Koshi, Boutique Elegance, 142 River Road
- Assigned Technician: Carlos Reyes
- Visit Date: August 6, 10:00 A.M.
- Technician Notes: Discovered a minor refrigerant leak in the copper connecting pipe. Repaired the joint and recharged the refrigerant system. Unit tested and operating at optimal 20°C.
Text 3: Follow-Up Email from Customer Support
To: k.koshi@eleganceboutique.com
From: support@coolmaxservice.com
Date: August 7
Dear Mr. Koshi,
We hope your cooling system is now running smoothly following Carlos''s visit yesterday. Because this issue occurred within the initial 30-day warranty window, the repair and refrigerant refill were completed free of charge. In addition, as an apology for the business disruption, we have credited $100 toward your annual maintenance contract.
Sincerely,
SBS Customer Care', N'image79.jpg', 14);
        SET @PassageId_7_13 = SCOPE_IDENTITY();
      
          DECLARE @QId_191 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_13, 191, N'Why did Mr. Koshi contact customer support?', N'Báo cáo máy điều hòa mới lắp bị ngừng làm mát.', 191);
          SET @QId_191 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_191, N'A', N'To order a replacement remote control', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_191, N'B', N'To report that an air conditioner stopped cooling', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_191, N'C', N'To request a pricing quote for a new unit', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_191, N'D', N'To schedule an annual filter cleaning', 0);
          
          DECLARE @QId_192 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_13, 192, N'What was the consequence of the cooling failure?', N'Cửa hàng phải đóng cửa sớm 2 tiếng vì quá nóng.', 192);
          SET @QId_192 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_192, N'A', N'The boutique had to close early.', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_192, N'B', N'Merchandise was ruined by water leaks.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_192, N'C', N'An electrical circuit tripped.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_192, N'D', N'Customers demanded refunds.', 0);
          
          DECLARE @QId_193 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_13, 193, N'What did technician Carlos Reyes find?', N'Phát hiện rò rỉ môi chất làm lạnh ở ống nối bằng đồng.', 193);
          SET @QId_193 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_193, N'A', N'A burned-out fan motor', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_193, N'B', N'A refrigerant leak in the connecting pipe', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_193, N'C', N'An incorrect thermostat setting', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_193, N'D', N'A blocked exterior ventilation duct', 0);
          
          DECLARE @QId_194 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_13, 194, N'Why was the service visit free of charge?', N'Sự cố xảy ra trong vòng 30 ngày bảo hành đầu tiên.', 194);
          SET @QId_194 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_194, N'A', N'Mr. Koshi is an executive VIP member.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_194, N'B', N'The problem occurred within the 30-day warranty period.', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_194, N'C', N'The company has a promotional free service week.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_194, N'D', N'The installation was delayed last month.', 0);
          
          DECLARE @QId_195 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_13, 195, N'How will SBS address Mr. Koshi''s inconvenience?', N'Tặng khoản tín dụng $100 trừ vào hợp đồng bảo trì hàng năm.', 195);
          SET @QId_195 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_195, N'A', N'By replacing the entire unit with a newer model', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_195, N'B', N'By giving him a $100 credit toward maintenance', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_195, N'C', N'By providing free filters for five years', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_195, N'D', N'By sending a floral arrangement to the store', 0);
          
        DECLARE @PassageId_7_14 INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_7, N'', N'Questions 196-200 refer to the following job advertisement, employment application, and letter of recommendation.
Text 1: Job Advertisement
Delphine Street Grill
3248 Delphine Street, New Orleans, LA 70117
Position: Line Cook
Established in 1924, Delphine Street Grill is seeking an experienced, passionate Line Cook to join our renowned culinary team. Candidates must possess formal culinary training, a minimum of two years of kitchen experience, and proficiency in preparing traditional Cajun and Creole cuisine. Responsibilities include preparing sauces, executing dinner service, and maintaining strict sanitation standards. Competitive hourly wages and healthcare benefits provided. Apply online at www.delphinestreetgrill.com/careers.
Text 2: Online Application
Name: Anton Hoang
E-mail: antonh94@textmail.com | Phone: 504.555.0177
Related education: Associate degree in culinary arts, Boudreau Community College
Current employer/title: River Ferry Café, Line Cook | Time employed: Six months
Previous employer/title: Hotel Lenoir, Apprentice | Time employed: Two years
Previous employer/title: Picard Seafood, Intern | Time employed: Three months
Cover Letter Summary:
I am very interested in the position of line cook at the Delphine Street Grill. For the past six months, I have been the line cook for a café serving traditional Cajun meals. I completed my two-year apprenticeship at the famous Hotel Lenoir, working side-by-side with Celebrity Chef Eugénie Mirone. In addition, as Ted Overbeck (my mentor and instructor at Boudreau Community College) can confirm, I was awarded the Excellence in Innovation Prize for a Vietnamese-style sandwich recipe I crafted, which is now featured on the college cafeteria menu.
Text 3: Recommendation Letter
BOUDREAU COMMUNITY COLLEGE - School of Culinary Arts
Marie Beaumont, Delphine Street Grill
3248 Delphine Street, New Orleans, LA 70117
Dear Ms. Beaumont:
I am writing in regard to Anton Hoang''s application for employment. Since Mr. Overbeck is on leave this semester, he asked me to respond in his place. Mr. Hoang, who graduated in the top five of his class, demonstrated exceptional culinary skill and a strong desire to learn. He received a glowing review from Sabine Riou, the renowned chef who supervised his three-month internship at Picard Seafood. I am confident Mr. Hoang will be a valuable asset to your establishment.
Sincerely,
Liz Flores
Associate Director of Culinary Arts', NULL, 15);
        SET @PassageId_7_14 = SCOPE_IDENTITY();
      
          DECLARE @QId_196 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_14, 196, N'What is indicated about the line cook position at Delphine Street Grill?', N'Yêu cầu kinh nghiệm nấu ăn các món Cajun và Creole truyền thống.', 196);
          SET @QId_196 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_196, N'A', N'It is a two-year contract.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_196, N'B', N'It requires working the late-night shift.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_196, N'C', N'It includes supervising apprentices.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_196, N'D', N'It requires kitchen experience in Cajun/Creole cuisine.', 1);
          
          DECLARE @QId_197 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_14, 197, N'What is true about Mr. Hoang?', N'Anh ấy đáp ứng đầy đủ tiêu chuẩn kinh nghiệm và bằng cấp của vị trí tuyển dụng.', 197);
          SET @QId_197 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_197, N'A', N'He is applying to work at several restaurants.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_197, N'B', N'He meets the qualifications of the position.', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_197, N'C', N'He has appeared on television with Ms. Mirone.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_197, N'D', N'He taught at a culinary school in Vietnam.', 0);
          
          DECLARE @QId_198 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_14, 198, N'Who is Mr. Overbeck?', N'Giảng viên và người hướng dẫn tại trường cao đẳng Boudreau Community College.', 198);
          SET @QId_198 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_198, N'A', N'An executive chef at Delphine Street Grill', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_198, N'B', N'An instructor at Boudreau Community College', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_198, N'C', N'A food critic for a local newspaper', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_198, N'D', N'The owner of River Ferry Café', 0);
          
          DECLARE @QId_199 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_14, 199, N'What is suggested about Boudreau Community College?', N'Trường trao giải thưởng ẩm thực (''Excellence in Innovation Prize'').', 199);
          SET @QId_199 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_199, N'A', N'It gives out culinary awards.', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_199, N'B', N'It offers free cooking workshops.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_199, N'C', N'It needs a new chef for its cafeteria.', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_199, N'D', N'It invites celebrity chefs as guest speakers.', 0);
          
          DECLARE @QId_200 INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_7, @PassageId_7_14, 200, N'Where does Ms. Riou most likely work?', N'Bà Sabine Riou là bếp trưởng tại Picard Seafood (nơi Anton thực tập 3 tháng).', 200);
          SET @QId_200 = SCOPE_IDENTITY();
        
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_200, N'A', N'At the River Ferry Café', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_200, N'B', N'At Hotel Lenoir', 0);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_200, N'C', N'At Picard Seafood', 1);
          
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_200, N'D', N'At the Delphine Street Grill', 0);
          
    COMMIT TRANSACTION;
    PRINT N'SEED MSSQL THANH CONG: 1 EXAM, 100 QUESTIONS, 400 ANSWERS!';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT N'SEED MSSQL THAT BAI: ' + ERROR_MESSAGE();
    THROW;
END CATCH
GO
